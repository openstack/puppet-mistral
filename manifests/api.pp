# == Class: mistral::api
#
# Installs & configure the Mistral API service
#
# === Parameters
#
# [*allow_action_execution_deletion*]
#   (Optional) Enables the ability to delete action_execution
#   which has no relationship with workflows. (boolean value).
#   Defaults to $facts['os_service_default'].
#
# [*api_workers*]
#   (Optional) Number of workers for Mistral API service
#   default is equal to the number of CPUs available if that can
#   be determined, else a default worker count of 1 is returned.
#   Defaults to $facts['os_workers']
#
# [*bind_host*]
#   (Optional) Address to bind the server. Useful when
#   selecting a particular network interface.
#   Defaults to $facts['os_service_default'].
#
# [*bind_port*]
#   (Optional) The port on which the server will listen.
#   Defaults to $facts['os_service_default'].
#
# [*enabled*]
#   (optional) Should the service be enabled.
#   Defaults to 'true'.
#
# [*manage_service*]
#   (optional) Whether the service should be managed by Puppet.
#   Defaults to 'true'.
#
# [*package_ensure*]
#    (Optional) Ensure state for package.
#    Defaults to present
#
# [*service_name*]
#   (optional) Name of the service that will be providing the
#   server functionality of mistral-api.
#   If the value is 'httpd', this means mistral-api will be a web
#   service, and you must use another class to configure that
#   web service. For example, use class { 'mistral::wsgi::apache'...}
#   to make mistral-api be a web app using apache mod_wsgi.
#   Defaults to '$mistral::params::api_service_name'
#
# [*enable_proxy_headers_parsing*]
#   (Optional) Enable paste middleware to handle SSL requests through
#   HTTPProxyToWSGI middleware.
#   Defaults to $facts['os_service_default'].
#
# [*max_request_body_size*]
#   (Optional) Set max request body size
#   Defaults to $facts['os_service_default'].
#
# [*auth_strategy*]
#   (optional) Type of authentication to be used.
#   Defaults to 'keystone'
#
class mistral::api (
  $allow_action_execution_deletion        = $facts['os_service_default'],
  $api_workers                            = $facts['os_workers'],
  $bind_host                              = $facts['os_service_default'],
  $bind_port                              = $facts['os_service_default'],
  Boolean $enabled                        = true,
  Boolean $manage_service                 = true,
  Stdlib::Ensure::Package $package_ensure = present,
  String[1] $service_name                 = $mistral::params::api_service_name,
  $enable_proxy_headers_parsing           = $facts['os_service_default'],
  $max_request_body_size                  = $facts['os_service_default'],
  $auth_strategy                          = 'keystone',
) inherits mistral::params {
  include mistral::deps
  include mistral::params
  include mistral::policy

  if $auth_strategy == 'keystone' {
    include mistral::keystone::authtoken
  }

  package { 'mistral-api':
    ensure => $package_ensure,
    name   => $mistral::params::api_package_name,
    tag    => ['openstack', 'mistral-package'],
  }

  if $manage_service {
    case $service_name {
      'httpd': {
        Service <| title == 'httpd' |> { tag +> 'mistral-service' }

        service { 'mistral-api':
          ensure => 'stopped',
          name   => $mistral::params::api_service_name,
          enable => false,
          tag    => 'mistral-service',
        }
        # we need to make sure mistral-api s stopped before trying to start apache
        Service['mistral-api'] -> Service['httpd']
      }
      default: {
        $service_ensure = $enabled ? {
          true    => 'running',
          default => 'stopped',
        }

        service { 'mistral-api':
          ensure     => $service_ensure,
          name       => $service_name,
          enable     => $enabled,
          hasstatus  => true,
          hasrestart => true,
          tag        => 'mistral-service',
        }
      }
    }
  }

  mistral_config {
    'api/api_workers'                      : value => $api_workers;
    'api/host'                             : value => $bind_host;
    'api/port'                             : value => $bind_port;
    'api/allow_action_execution_deletion'  : value => $allow_action_execution_deletion;
  }

  oslo::middleware { 'mistral_config':
    enable_proxy_headers_parsing => $enable_proxy_headers_parsing,
    max_request_body_size        => $max_request_body_size,
  }
}
