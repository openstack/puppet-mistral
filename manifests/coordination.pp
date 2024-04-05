# == Class: mistral::coordination
#
# Setup and configure Mistral coordination settings.
#
# === Parameters
#
# [*backend_url*]
#   (Optional) Coordination backend URL.
#   Defaults to $facts['os_service_default']
#
# DEPRECATED PARAMETERS
#
# [*heartbeat_interval*]
#   (Optional) Number of seconds between heartbeats for coordination.
#   Defaults to undef
#
class mistral::coordination (
  $backend_url        = $facts['os_service_default'],
  # DEPRECATED PARAMETERS
  $heartbeat_interval = undef,
) {

  include mistral::deps

  if $heartbeat_interval != undef {
    warning('The heartbeat_interval parameter has been deprecated and has no effect.')
  }

  oslo::coordination{ 'mistral_config':
    backend_url => $backend_url
  }

  mistral_config {
    'coordination/heartbeat_interval': ensure => absent;
  }

  # all coordination settings should be applied and all packages should be
  # installed before service startup
  Oslo::Coordination['mistral_config'] -> Anchor['mistral::service::begin']
}
