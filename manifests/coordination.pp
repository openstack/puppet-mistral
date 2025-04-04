# == Class: mistral::coordination
# DEPRECATED !!
# Setup and configure Mistral coordination settings.
#
# === Parameters
#
# [*backend_url*]
#   (Optional) Coordination backend URL.
#   Defaults to $facts['os_service_default']
#
class mistral::coordination (
  $backend_url = $facts['os_service_default'],
) {

  include mistral::deps

  warning('Support for coordination has been deprecated.')

  oslo::coordination{ 'mistral_config':
    backend_url => $backend_url
  }

  # all coordination settings should be applied and all packages should be
  # installed before service startup
  Oslo::Coordination['mistral_config'] -> Anchor['mistral::service::begin']
}
