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
# [*version*]
#   (Optional) The version of the engine. (string value)
#   Defaults to $::os_service_default.
#
# [*execution_field_size_limit_kb*]
#   (Optional) The default maximum size in KB of large text fields
#   of runtime execution objects. Use -1 for no limit.
#   Defaults to $::os_service_default.
#
# [*evaluation_interval*]
#   (Optional) How often will the executions be evaluated
#   (in minutes). For example for value 120 the interval
#   will be 2 hours (every 2 hours).
#   Defaults to $::os_service_default.
#
# [*older_than*]
#   (Optional) Evaluate from which time remove executions in minutes.
#   For example when older_than = 60, remove all executions
#   that finished a 60 minutes ago or more.
#   Minimum value is 1.
#   Note that only final state execution will remove (SUCCESS/ERROR).
#   Defaults to $::os_service_default.
#
class mistral::engine (
  $package_ensure                = present,
  $manage_service                = true,
  $enabled                       = true,
  $host                          = $::os_service_default,
  $topic                         = $::os_service_default,
  $version                       = $::os_service_default,
  $execution_field_size_limit_kb = $::os_service_default,
  $evaluation_interval           = $::os_service_default,
  $older_than                    = $::os_service_default,
) {

  include ::mistral::deps
  include ::mistral::params

  package { 'mistral-engine':
    ensure => $package_ensure,
    name   => $::mistral::params::engine_package_name,
    tag    => ['openstack', 'mistral-package'],
  }

  if $manage_service {
    if $enabled {
      $service_ensure = 'running'
    } else {
      $service_ensure = 'stopped'
    }
  }

  service { 'mistral-engine':
    ensure     => $service_ensure,
    name       => $::mistral::params::engine_service_name,
    enable     => $enabled,
    hasstatus  => true,
    hasrestart => true,
    tag        => 'mistral-service',
  }

  mistral_config {
    'engine/host':                                     value => $host;
    'engine/topic':                                    value => $topic;
    'engine/version':                                  value => $version;
    'engine/execution_field_size_limit_kb':            value => $execution_field_size_limit_kb;
    'execution_expiration_policy/evaluation_interval': value => $evaluation_interval;
    'execution_expiration_policy/older_than':          value => $older_than;
  }

}
