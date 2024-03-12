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
# [*heartbeat_interval*]
#   (Optional) Number of seconds between heartbeats for coordination.
#   Defaults to $facts['os_service_default']
#
class mistral::coordination (
  $backend_url        = $facts['os_service_default'],
  $heartbeat_interval = $facts['os_service_default'],
) {

  include mistral::deps

  oslo::coordination{ 'mistral_config':
    backend_url => $backend_url
  }

  mistral_config {
    'coordination/heartbeat_interval': value => $heartbeat_interval;
  }

  # all coordination settings should be applied and all packages should be
  # installed before service startup
  Oslo::Coordination['mistral_config'] -> Anchor['mistral::service::begin']
}
