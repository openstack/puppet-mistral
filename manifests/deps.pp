# == Class: mistral::deps
#
#  mistral anchors and dependency management
#
class mistral::deps {
  # Setup anchors for install, config and service phases of the module.  These
  # anchors allow external modules to hook the begin and end of any of these
  # phases.  Package or service management can also be replaced by ensuring the
  # package is absent or turning off service management and having the
  # replacement depend on the appropriate anchors.  When applicable, end tags
  # should be notified so that subscribers can determine if installation,
  # config or service state changed and act on that if needed.
  anchor { 'mistral::install::begin': }
  -> Package<| tag == 'mistral-package'|>
  ~> anchor { 'mistral::install::end': }
  -> anchor { 'mistral::config::begin': }
  -> Mistral_config<||>
  ~> anchor { 'mistral::config::end': }
  -> anchor { 'mistral::db::begin': }
  -> anchor { 'mistral::db::end': }
  ~> anchor { 'mistral::dbsync::begin': }
  -> anchor { 'mistral::dbsync::end': }
  ~> anchor { 'mistral::service::begin': }
  ~> Service<| tag == 'mistral-service' |>
  ~> anchor { 'mistral::service::end': }

  Anchor['mistral::config::begin']
  -> Mistral_api_uwsgi_config<||>
  -> Anchor['mistral::config::end']

  # We need openstackclient before marking service end so that mistral
  # will have clients available to create resources. This tag handles the
  # openstackclient but indirectly since the client is not available in
  # all catalogs that don't need the client class (like many spec tests)
  Package<| tag == 'openstackclient'|>
  -> Anchor['mistral::service::end']

  # Installation or config changes will always restart services.
  Anchor['mistral::install::end'] ~> Anchor['mistral::service::begin']
  Anchor['mistral::config::end']  ~> Anchor['mistral::service::begin']
}
