# == Class: mistral::notifier
#
# Configure the mistral notifier
#
# === Parameters
#
# [*package_ensure*]
#    (Optional) Ensure state for package.
#    Defaults to present
#
# [*enabled*]
#   (optional) Should the service be enabled.
#   Defaults to true.
#
# [*manage_service*]
#   (optional) Whether the service should be managed by Puppet.
#   Defaults to true.
#
# [*type*]
#   (Optional) Type of notifier. Use local to run the notifier within
#   the engine server. Use remote if the notifier is launched as a separate
#   server to process events.
#   (string value)
#   Defaults to 'remote'.
#
# [*host*]
#   (Optional) Name of the notifier node. This can be an opaque identifier.
#   It is not necessarily a hostname, FQDN, or IP address.
#   (string value)
#   Defaults to $facts['os_service_default'].
#
# [*topic*]
#   (Optional) The message topic that the notifier server listens on.
#   (string value)
#   Defaults to $facts['os_service_default'].
#
# [*notify_publishers*]
#   (Optional) List of publishers to publish notification.
#   Note: This maps to the mistral config option `notify` but this is reserved
#   in Puppet.
#   (list of dicts)
#   Defaults to $facts['os_service_default'].
#
class mistral::notifier(
  $package_ensure               = present,
  Boolean $manage_service       = true,
  Boolean $enabled              = true,
  Enum['local', 'remote'] $type = 'remote',
  $host                         = $facts['os_service_default'],
  $topic                        = $facts['os_service_default'],
  $notify_publishers            = $facts['os_service_default'],
) {

  include mistral::deps
  include mistral::params

  if $mistral::params::notifier_package_name {
    package { 'mistral-notifier':
      ensure => $package_ensure,
      name   => $mistral::params::notifier_package_name,
      tag    => ['openstack', 'mistral-package'],
    }
  }

  if $manage_service {
    $enabled_real = $type ? {
      'remote' => $enabled,
      default  => false,
    }

    if $enabled_real {
      $service_ensure = 'running'
    } else {
      $service_ensure = 'stopped'
    }

    if $mistral::params::notifier_service_name {
      service { 'mistral-notifier':
        ensure     => $service_ensure,
        name       => $mistral::params::notifier_service_name,
        enable     => $enabled_real,
        hasstatus  => true,
        hasrestart => true,
        tag        => 'mistral-service',
      }
      Service['mistral-notifier'] -> Service<| title == 'mistral-engine' |>
    } else {
      warning('mistral-notifier service is not available')
    }
  }

  mistral_config {
    'notifier/type':   value => $type;
    'notifier/host':   value => $host;
    'notifier/topic':  value => $topic;
    'notifier/notify': value => $notify_publishers;
  }
}
