#
class mistral::params {
  $mistral_conf_dir = '/etc/mistral'
  $mistral_conf = "${mistral_conf_dir}/mistral.conf"
  $package_name       = 'mistral'
  $client_package     = 'python-mistralclient'
  $log_dir ='/var/log/mistral'
  $dbsync_command = "/usr/bin/python /usr/bin/mistral-db-manage --config-file=${mistral_conf} populate"
  $update_service_command = '/usr/bin/systemctl daemon-reload'
}
