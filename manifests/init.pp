# == Class: mistral
#
# Full description of class mistral here.
#
# === Parameters
#  [*qpid_hostname*]
#  The name/ip of qpid. Defult 'localhost'
#
#  [*qpid_port*]
#  The port of qpid. Defult '5671'
#
#  [*qpid_username*]
#  User name for qpid. Defult 'guest'
#
#  [*qpid_password*]
#  password for qpid. Defult 'guest'
#
#  [*qpid_protocol*]
#  protocol for qpid. Defult 'ssl'
#
#  [*qpid_tcp_nodelay*]
#  Shuld tcp be no deply at qpid? defult 'true'
#
#  [*rpc_backend*]
#  The rpc backend defult 'qpid'
#
#  [*auth_uri*]
#  Keystone url. Defult 'http://localhost:5000/v2.0/'
#
#  [*admin_user*]
#  The user name from 'mistral::keystone::auth'. Defult 'mistral'
#
#  [*admin_tenant_name*]
#  The tenant name from 'mistral::keystone::auth'. Defult 'service'
#
#  [*admin_password*]
#  The password  from 'mistral::keystone::auth'. Defult 'password'
#
#  [*log_dir*]
#  Path to the log dir. Defult '$::mistral::params::log_dir'
#
#  [*mysql_vip*]
#  ip for the my sql DB. Defult '127.0.0.1'
#
#  [*mistral_db_pass*]
#  password for thr DB. Shulde be the same as mistral::db::mysql.
#  Defult 'password'
#
#  [*auth_version*]
#  Keystone Api versioh. Defult 'v2.0'
#
# [*rabbit_hostname*]
# The name/ip of rabbit. Defult 'localhost'
#
# [*rabbit_userid*]
# User id for rabbit. Defult 'guest'
#
# [*rabbit_password*]
# password for rabbit. Defult 'guest'
#
# [*rabbit_port*]
# The port of rabbit. Defult '5671'
#
# [*auth_protocol*]
# Keystone protocol
#
class mistral(
  $qpid_hostname     = 'localhost',
  $qpid_port         =  5671,
  $qpid_username     = 'guest',
  $qpid_password     = 'guest',
  $qpid_protocol     = 'ssl',
  $qpid_tcp_nodelay  = true,
  $rpc_backend       = 'qpid',
  $auth_uri          = 'http://localhost:5000/v2.0/',
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
  $rabbit_port       = 5671
){
  include ::mistral::params

  group { 'mistral':
    ensure => 'present',
    name   => 'mistral',
  }

  file { '/home/mistral' :
    ensure => directory,
    owner  => 'mistral',
    group  => 'mistral',
    mode   => '0750',
  }

  user { 'mistral':
    name   => 'mistral',
    gid    => 'mistral',
    groups => ['mistral'],
    home   => '/home/mistral',
    system => true
  }


  package { 'MySQL-python':
    ensure => installed,
    name   => 'MySQL-python',
  }

  package { 'python-devel':
    ensure => installed,
    name   => 'python-devel',
  }

  package { 'python-pip':
    ensure => installed,
    name   => 'python-pip',
  }

  package { 'python-keystonemiddleware':
    ensure => latest,
    name   => 'python-keystonemiddleware',
  }

  package { 'python-oslo-utils':
    ensure => latest,
    name   => 'python-oslo-utils',
  }

  package { 'python-oslo-db':
    ensure => latest,
    name   => 'python-oslo-db',
  }

  package { 'python-oslo-log':
    ensure => latest,
    name   => 'python-oslo-log',
  }

  package { 'python-oslo-service':
    ensure => latest,
    name   => 'python-oslo-service',
  }

  package { 'python-oslo-i18n':
    ensure => latest,
    name   => 'python-oslo-i18n',
  }

  package { 'python-oslo-config':
    ensure => latest,
    name   => 'python-oslo-config',
  }

  package { 'python-oslo-messaging':
    ensure => latest,
    name   => 'python-oslo-messaging',
  }

  package { 'python-oslo-context':
    ensure => latest,
    name   => 'python-oslo-context',
  }

  package { 'python-oslo-serialization':
    ensure => latest,
    name   => 'python-oslo-serialization',
  }

  package { 'python-novaclient':
    ensure => latest,
    name   => 'python-novaclient',
  }

  package { 'python-eventlet':
    ensure => latest,
    name   => 'python-eventlet',
  }


  package { 'yaql':
    ensure => installed,
    name   => 'yaql',
  }

  package { 'python-pecan':
    ensure => latest,
    name   => 'python-pecan',
  }

  package { 'python-ply':
    ensure => installed,
    name   => 'python-ply',
  }

  package { 'python-jsonschema':
    ensure => installed,
    name   => 'python-jsonschema',
  }

  package { 'python-croniter':
    ensure => installed,
    name   => 'python-croniter',
  }

  package { 'python-networkx':
    ensure => installed,
    name   => 'python-networkx',
  }

  package { 'python-warlock':
    ensure => installed,
    name   => 'python-warlock',
  }

  package { 'python-cliff':
    ensure => installed,
    name   => 'python-cliff',
  }

  package { 'python-wsme':
    ensure => installed,
    name   => 'python-wsme',
  }

  package { 'python-paramiko':
    ensure => installed,
    name   => 'python-paramiko',
  }

  package { 'mistral':
    ensure => latest,
    name   => 'mistral',
  }

  $auth_uri_with_version = "${auth_uri}${auth_version}/"
  $database_connection = "mysql://mistral:${mistral_db_pass}@${mysql_vip}/mistral"
  mistral_config {
    'DEFAULT/log_dir'                      : value  => $log_dir;
    'DEFAULT/rpc_backend'                  : value  => $rpc_backend;
    'keystone_authtoken/auth_uri'          : value  =>
      $auth_uri_with_version;
    'keystone_authtoken/auth_version'      : value  => $auth_version;
    'keystone_authtoken/auth_protocol'     : value  => $auth_protocol;
    'keystone_authtoken/identity_uri'      : value  => $auth_uri;
    'keystone_authtoken/admin_user'        : value  => $admin_user;
    'keystone_authtoken/admin_password'    : value  => $admin_password;
    'keystone_authtoken/admin_tenant_name' : value  => $admin_tenant_name;
    'database/connection' : value  => $database_connection;
  }
  if $rpc_backend == 'qpid' {
    mistral_config {
      'oslo_messaging_qpid/qpid_hostname'    : value  => $qpid_hostname;
      'oslo_messaging_qpid/qpid_port'        : value  => $qpid_port;
      'oslo_messaging_qpid/qpid_username'    : value  => $qpid_username;
      'oslo_messaging_qpid/qpid_password'    : value  => $qpid_password;
      'oslo_messaging_qpid/qpid_protocol'    : value  => $qpid_protocol;
      'oslo_messaging_qpid/qpid_tcp_nodelay' : value  => $qpid_tcp_nodelay;
    }
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

