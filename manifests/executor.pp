# == Class: mistral::executor
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
#   (Optional) Name of the executor node. This can be an opaque identifier.
#   It is not necessarily a hostname, FQDN, or IP address. (string value)
#   Defaults to $::os_service_default.
#
# [*topic*]
#   (Optional) The message topic that the executor listens on. (string value)
#   Defaults to $::os_service_default.
#
# [*version*]
#   (Optional) The version of the executor. (string value)
#   Defaults to $::os_service_default.
#
class mistral::executor (
  $package_ensure      = present,
  $manage_service      = true,
  $enabled             = true,
  $host                = $::os_service_default,
  $topic               = $::os_service_default,
  $version             = $::os_service_default,
) {

  include mistral::deps
  include mistral::params

  package { 'mistral-executor':
    ensure => $package_ensure,
    name   => $::mistral::params::executor_package_name,
    tag    => ['openstack', 'mistral-package'],
  }

  if $manage_service {
    if $enabled {
      $service_ensure = 'running'
    } else {
      $service_ensure = 'stopped'
    }

    service { 'mistral-executor':
      ensure     => $service_ensure,
      name       => $::mistral::params::executor_service_name,
      enable     => $enabled,
      hasstatus  => true,
      hasrestart => true,
      tag        => 'mistral-service',
    }
  }

  mistral_config {
    'executor/host':    value => $host;
    'executor/topic':   value => $topic;
    'executor/version': value => $version;
  }

}
