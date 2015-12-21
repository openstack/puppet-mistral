# == Class: mistral::params
#
# Parameters for puppet-mistral
#
class mistral::params {
  $mistral_conf_dir = '/etc/mistral'
  $mistral_conf = "${mistral_conf_dir}/mistral.conf"
  $client_package     = 'python-mistralclient'
  $log_dir ='/var/log/mistral'
  $dbsync_command = "/usr/bin/python /usr/bin/mistral-db-manage --config-file=${mistral_conf} populate"
  $update_service_command = '/usr/bin/systemctl daemon-reload'

  case $::osfamily {
    'RedHat': {
      $common_package_name = 'openstack-mistral-common'
      $api_package_name    = 'openstack-mistral-api'
      $api_service_name    = 'openstack-mistral-api'
    }
    'Debian': {
      $common_package_name = 'mistral'
      $api_package_name    = 'mistral-api'
      $api_service_name    = 'mistral-api'
    }
    default: {
      fail("Unsupported osfamily: ${::osfamily} operatingsystem: \
      ${::operatingsystem}, module ${module_name} only support osfamily \
      RedHat and Debian")
    }
  }
}
