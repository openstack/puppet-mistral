# == Class: mistral::engine
#
# Installs & configure the Mistral Engine service
#
# === Parameters
# [*package_ensure*]
#    (Optional) Ensure state for package.
#    Defaults to present
#
# [*enabled*]
#   (optional) Should the service be enabled.
#   Defaults to 'true'.
#
# [*manage_service*]
#   (optional) Whether the service should be managed by Puppet.
#   Defaults to 'true'.
#
# [*host*]
#   (Optional) Name of the engine node. This can be an opaque identifier.
#   It is not necessarily a hostname, FQDN, or IP address. (string value)
#   Defaults to $::os_service_default.
#
# [*topic*]
#   (Optional) The message topic that the engine listens on.
#   Defaults to $::os_service_default.
#
# [*event_definitions_cfg_file*]
#   (Optional) The path to the event_definitions config file.
#   Defaults to $::os_service_default.
#
class mistral::event_engine (
  $package_ensure                = present,
  $manage_service                = true,
  $enabled                       = true,
  $host                          = $::os_service_default,
  $topic                         = $::os_service_default,
  $event_definitions_cfg_file    = $::os_service_default,
) {

  include ::mistral::deps
  include ::mistral::params

  package { 'mistral-event-engine':
    ensure => $package_ensure,
    name   => $::mistral::params::event_engine_package_name,
    tag    => ['openstack', 'mistral-package'],
  }

  if $manage_service {
    if $enabled {
      $service_ensure = 'running'
    } else {
      $service_ensure = 'stopped'
    }
  }

  service { 'mistral-event-engine':
    ensure     => $service_ensure,
    name       => $::mistral::params::event_engine_service_name,
    enable     => $enabled,
    hasstatus  => true,
    hasrestart => true,
    tag        => 'mistral-service',
  }

  mistral_config {
    'event_engine/host':                         value => $host;
    'event_engine/topic':                        value => $topic;
    'event_engine/event_definitions_cfg_file':   value => $event_definitions_cfg_file;
  }

}
