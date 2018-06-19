# == Class: mistral::api
#
# Installs & configure the Mistral API service
#
# === Parameters
#
# [*allow_action_execution_deletion*]
#   (Optional) Enables the ability to delete action_execution
#   which has no relationship with workflows. (boolean value).
#   Defaults to $::os_service_default.
#
# [*api_workers*]
#   (Optional) Number of workers for Mistral API service
#   default is equal to the number of CPUs available if that can
#   be determined, else a default worker count of 1 is returned.
#   Defaults to $::os_workers
#
# [*bind_host*]
#   (Optional) Address to bind the server. Useful when
#   selecting a particular network interface.
#   Defaults to $::os_service_default.
#
# [*bind_port*]
#   (Optional) The port on which the server will listen.
#   Defaults to $::os_service_default.
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
#   Defaults to '$::mistral::params::api_service_name'
#
# [*enable_proxy_headers_parsing*]
#   (Optional) Enable paste middleware to handle SSL requests through
#   HTTPProxyToWSGI middleware.
#   Defaults to $::os_service_default.
#
# [*auth_strategy*]
#   (optional) Type of authentication to be used.
#   Defaults to 'keystone'
#
class mistral::api (
  $allow_action_execution_deletion = $::os_service_default,
  $api_workers                     = $::os_workers,
  $bind_host                       = $::os_service_default,
  $bind_port                       = $::os_service_default,
  $enabled                         = true,
  $manage_service                  = true,
  $package_ensure                  = present,
  $service_name                    = $::mistral::params::api_service_name,
  $enable_proxy_headers_parsing    = $::os_service_default,
  $auth_strategy                   = 'keystone',
) inherits mistral::params {

  include ::mistral::deps
  include ::mistral::params
  include ::mistral::policy

  if $auth_strategy == 'keystone' {
    include ::mistral::keystone::authtoken
  }

  package { 'mistral-api':
    ensure => $package_ensure,
    name   => $::mistral::params::api_package_name,
    tag    => ['openstack', 'mistral-package'],
  }

  if $manage_service {
    if $enabled {
      $service_ensure = 'running'
    } else {
      $service_ensure = 'stopped'
    }
  }

  if $service_name == $::mistral::params::api_service_name {
    service { 'mistral-api':
      ensure     => $service_ensure,
      name       => $::mistral::params::api_service_name,
      enable     => $enabled,
      hasstatus  => true,
      hasrestart => true,
      tag        => 'mistral-service',
    }
  } elsif $service_name == 'httpd' {
    include ::apache::params
    service { 'mistral-api':
      ensure => 'stopped',
      name   => $::mistral::params::api_service_name,
      enable => false,
      tag    => 'mistral-service',
    }
    Service <| title == 'httpd' |> { tag +> 'mistral-service' }

    # we need to make sure mistral-api s stopped before trying to start apache
    Service['mistral-api'] -> Service[$service_name]
  } else {
    fail("Invalid service_name. Either mistral/openstack-mistral-api for running \
as a standalone service, or httpd for being run by a httpd server")
  }

  mistral_config {
    'api/api_workers'                      : value => $api_workers;
    'api/host'                             : value => $bind_host;
    'api/port'                             : value => $bind_port;
    'api/allow_action_execution_deletion'  : value => $allow_action_execution_deletion;
  }

  oslo::middleware { 'mistral_config':
    enable_proxy_headers_parsing => $enable_proxy_headers_parsing,
  }

}
