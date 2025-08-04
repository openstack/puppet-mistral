# == Class: mistral::executor
#
# Installs & configure the Mistral Engine service
#
# === Parameters
# [*package_ensure*]
#   (Optional) Ensure state for package.
#   Defaults to present
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
#   (Optional) Type of executor. Use local to run the executor within
#   the engine server. Use remote if the executor is launched as a separate
#   server to process events.
#   (string value)
#   Defaults to 'remote'.
#
# [*host*]
#   (Optional) Name of the executor node. This can be an opaque identifier.
#   It is not necessarily a hostname, FQDN, or IP address. (string value)
#   Defaults to $facts['os_service_default'].
#
# [*topic*]
#   (Optional) The message topic that the executor listens on. (string value)
#   Defaults to $facts['os_service_default'].
#
# [*version*]
#   (Optional) The version of the executor. (string value)
#   Defaults to $facts['os_service_default'].
#
class mistral::executor (
  $package_ensure               = present,
  Boolean $manage_service       = true,
  Boolean $enabled              = true,
  Enum['local', 'remote'] $type = 'remote',
  $host                         = $facts['os_service_default'],
  $topic                        = $facts['os_service_default'],
  $version                      = $facts['os_service_default'],
) {

  include mistral::deps
  include mistral::params

  package { 'mistral-executor':
    ensure => $package_ensure,
    name   => $::mistral::params::executor_package_name,
    tag    => ['openstack', 'mistral-package'],
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

    service { 'mistral-executor':
      ensure     => $service_ensure,
      name       => $::mistral::params::executor_service_name,
      enable     => $enabled_real,
      hasstatus  => true,
      hasrestart => true,
      tag        => 'mistral-service',
    }
  }

  mistral_config {
    'executor/type':    value => $type;
    'executor/host':    value => $host;
    'executor/topic':   value => $topic;
    'executor/version': value => $version;
  }

}
