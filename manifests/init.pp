# == Class: mistral
#
# Full description of class mistral here.
#
# === Parameters
# [*package_ensure*]
#  (Optional) Ensure state for package.
#  Defaults to 'present'
#
#  [*rpc_backend*]
#  The rpc backend. Default 'rabbit'
#
#  [*auth_uri*]
#  Specifies the public Identity URI for Mistral to use.
#  Default 'http://localhost:5000/v2.0/'

# [*identity_uri*]
#  Specifies the admin Identity URI for Mistral to use.
#  Default 'http://localhost:35357/'
#
#  [*admin_user*]
#  The user name from 'mistral::keystone::auth'. Default 'mistral'
#
#  [*admin_tenant_name*]
#  The tenant name from 'mistral::keystone::auth'. Default 'service'
#
#  [*admin_password*]
#  The password  from 'mistral::keystone::auth'. Default 'password'
#
#  [*log_dir*]
#  Path to the log dir. Default '$::mistral::params::log_dir'
#
#  [*mysql_vip*]
#  ip for the my sql DB. Default '127.0.0.1'
#
#  [*mistral_db_pass*]
#  password for thr DB. Shulde be the same as mistral::db::mysql.
#  Default 'password'
#
#  [*auth_version*]
#  Keystone Api version. Default 'v2.0'
#
# [*rabbit_hostname*]
# The name/ip of rabbit. Default 'localhost'
#
# [*rabbit_userid*]
# User id for rabbit. Default 'guest'
#
# [*rabbit_password*]
# password for rabbit. Default 'guest'
#
# [*rabbit_port*]
# The port of rabbit. Default $::os_service_default
#
# [*auth_protocol*]
# Keystone protocol
#
# DEPRECATED PARAMETERS
#
#  [*qpid_hostname*]
#  The name/ip of qpid. Default undef
#
#  [*qpid_port*]
#  The port of qpid. Default undef
#
#  [*qpid_username*]
#  User name for qpid. Default undef
#
#  [*qpid_password*]
#  password for qpid. Default undef
#
#  [*qpid_protocol*]
#  protocol for qpid. Default undef
#
#  [*qpid_tcp_nodelay*]
#  Should tcp be no delay for qpid. Default undef
#
class mistral(
  $package_ensure    = 'present',
  $rpc_backend       = 'rabbit',
  $auth_uri          = 'http://localhost:5000/v2.0/',
  $identity_uri      = 'http://localhost:35357/',
  $admin_user        = 'mistral',
  $admin_tenant_name = 'services',
  $admin_password    = 'password',
  $log_dir           = $::mistral::params::log_dir,
  $mysql_vip         = '127.0.0.1',
  $mistral_db_pass   = 'password',
  $auth_version      = 'v2.0',
  $auth_protocol     = 'http',
  $rabbit_hostname   = 'localhost',
  $rabbit_userid     = 'guest',
  $rabbit_password   = 'guest',
  $rabbit_port       = $::os_service_default,
  # DEPRECATED PARAMETERS
  $qpid_hostname     = undef,
  $qpid_port         = undef,
  $qpid_username     = undef,
  $qpid_password     = undef,
  $qpid_protocol     = undef,
  $qpid_tcp_nodelay  = undef,
){
  include ::mistral::params

  package { 'mistral-common':
    ensure => $package_ensure,
    name   => $::mistral::params::common_package_name,
    tag    => ['openstack', 'mistral-package'],
  }

  $database_connection = "mysql://mistral:${mistral_db_pass}@${mysql_vip}/mistral"
  mistral_config {
    'DEFAULT/log_dir'                      : value  => $log_dir;
    'DEFAULT/rpc_backend'                  : value  => $rpc_backend;
    'keystone_authtoken/auth_uri'          : value  => $auth_uri;
    'keystone_authtoken/identity_uri'      : value  => $identity_uri;
    'keystone_authtoken/auth_version'      : value  => $auth_version;
    'keystone_authtoken/auth_protocol'     : value  => $auth_protocol;
    'keystone_authtoken/admin_user'        : value  => $admin_user;
    'keystone_authtoken/admin_password'    : value  => $admin_password;
    'keystone_authtoken/admin_tenant_name' : value  => $admin_tenant_name;
    'database/connection' : value  => $database_connection;
  }
  if $rpc_backend == 'qpid' {
    warning('Qpid driver is removed from Oslo.messaging in the Mitaka release')
  }
  if $rpc_backend == 'rabbit' {
    mistral_config {
      'oslo_messaging_rabbit/rabbit_host'    : value  => $rabbit_hostname;
      'oslo_messaging_rabbit/rabbit_port'        : value  => $rabbit_port;
      'oslo_messaging_rabbit/rabbit_userid'    : value  => $rabbit_userid;
      'oslo_messaging_rabbit/rabbit_password'    : value  => $rabbit_password;
    }
  }
}
