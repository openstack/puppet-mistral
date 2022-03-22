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
# [*execution_integrity_check_delay*]
#   (Optional) A number of seconds since the last update of a task execution
#   in RUNNING state after which Mistral will start checking its integrity.
#   Defaults to $::os_service_default.
#
# [*execution_integrity_check_batch_size*]
#   (Optional) A number of task executions in RUNNING state that the execution
#   integurity checker can process in a single iteration.
#   Defaults to $::os_service_default.
#
# [*action_definition_cache_time*]
#   (Optional) A number of seconds that indicates how long action definitions
#   should be stored in the local cache.
#   Defaults to $::os_service_default.
#
# [*start_subworkflows_via_rpc*]
#   (Optional) Enables startin subworkflows via RPC.
#   Defaults to $::os_service_default.
#
# DEPRECATED PARAMETERS
#
# [*evaluation_interval*]
#   (Optional) How often will the executions be evaluated
#   (in minutes). For example for value 120 the interval
#   will be 2 hours (every 2 hours).
#   Defaults to undef.
#
# [*older_than*]
#   (Optional) Evaluate from which time remove executions in minutes.
#   For example when older_than = 60, remove all executions
#   that finished a 60 minutes ago or more.
#   Minimum value is 1.
#   Note that only final state execution will remove (SUCCESS/ERROR).
#   Defaults to undef.
#
class mistral::engine (
  $package_ensure                       = present,
  $manage_service                       = true,
  $enabled                              = true,
  $host                                 = $::os_service_default,
  $topic                                = $::os_service_default,
  $version                              = $::os_service_default,
  $execution_field_size_limit_kb        = $::os_service_default,
  $execution_integrity_check_delay      = $::os_service_default,
  $execution_integrity_check_batch_size = $::os_service_default,
  $action_definition_cache_time         = $::os_service_default,
  $start_subworkflows_via_rpc           = $::os_service_default,
  # DEPRECATED PARAMETERS
  $evaluation_interval                  = undef,
  $older_than                           = undef,
) {

  include mistral::deps
  include mistral::params

  if $evaluation_interval != undef {
    warning('The mistral::engine::evaluation_interval parameter is deprecated. \
Use the mistral::execution_expiration_policy class instead.')
  }
  if $older_than != undef {
    warning('The mistral::engine::older_than parameter is deprecated. \
Use the mistral::execution_expiration_policy class instead.')
  }
  include mistral::execution_expiration_policy

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

    service { 'mistral-engine':
      ensure     => $service_ensure,
      name       => $::mistral::params::engine_service_name,
      enable     => $enabled,
      hasstatus  => true,
      hasrestart => true,
      tag        => 'mistral-service',
    }
  }

  mistral_config {
    'engine/host':                                 value => $host;
    'engine/topic':                                value => $topic;
    'engine/version':                              value => $version;
    'engine/execution_field_size_limit_kb':        value => $execution_field_size_limit_kb;
    'engine/execution_integrity_check_delay':      value => $execution_integrity_check_delay;
    'engine/execution_integrity_check_batch_size': value => $execution_integrity_check_batch_size;
    'engine/action_definition_cache_time':         value => $action_definition_cache_time;
    'engine/start_subworkflows_via_rpc':           value => $start_subworkflows_via_rpc;
  }
}
