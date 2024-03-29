# == Class: mistral::params
#
# Parameters for puppet-mistral
#
class mistral::params {
  include openstacklib::defaults

  $client_package      = 'python3-mistralclient'
  $db_sync_command     = 'mistral-db-manage upgrade head'
  $db_populate_command = 'mistral-db-manage populate'
  $user                = 'mistral'
  $group               = 'mistral'

  case $facts['os']['family'] {
    'RedHat': {
      $common_package_name        = 'openstack-mistral-common'
      $api_package_name           = 'openstack-mistral-api'
      $api_service_name           = 'openstack-mistral-api'
      $engine_package_name        = 'openstack-mistral-engine'
      $engine_service_name        = 'openstack-mistral-engine'
      $executor_package_name      = 'openstack-mistral-executor'
      $executor_service_name      = 'openstack-mistral-executor'
      $event_engine_package_name  = 'openstack-mistral-event-engine'
      $event_engine_service_name  = 'openstack-mistral-event-engine'
      $mistral_wsgi_script_path   = '/var/www/cgi-bin/mistral'
      $mistral_wsgi_script_source = '/usr/bin/mistral-wsgi-api'
    }
    'Debian': {
      $common_package_name        = 'mistral-common'
      $api_package_name           = 'mistral-api'
      $api_service_name           = 'mistral-api'
      $engine_package_name        = 'mistral-engine'
      $engine_service_name        = 'mistral-engine'
      $executor_package_name      = 'mistral-executor'
      $executor_service_name      = 'mistral-executor'
      $event_engine_package_name  = 'mistral-event-engine'
      $event_engine_service_name  = 'mistral-event-engine'
      $mistral_wsgi_script_path   = '/usr/lib/cgi-bin/mistral'
      $mistral_wsgi_script_source = '/usr/bin/mistral-wsgi-api'
    }
    default: {
      fail("Unsupported osfamily: ${facts['os']['family']}")
    }
  }
}
