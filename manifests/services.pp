# == Class: mistral::services
#
# Start mistral services
#
# === Parameters
#
# [*is_engine*]
#  start mistral engine? Defaults to 'true'.
#
# [*is_api*]
#  start mistral api? Defaults to 'true'.
#
# [*is_executor*]
#  start mistral executor? Defaults to 'true'.
#
# [*conf_file*]
#  path to the conf file. Defaults '$::mistral::params::mistral_conf'
#
class mistral::services(
  $is_engine   = true,
  $is_api      = true,
  $is_executor = true,
  $conf_file   = $::mistral::params::mistral_conf
) {

  if $is_engine {
    notify { 'Start mistral-engine': }

    file { 'openstack-mistral-engine':
      path    => '/usr/lib/systemd/system/openstack-mistral-engine
      .service',
      owner   => 'mistral',
      group   => 'mistral',
      mode    => '0644',
      content => template('mistral/openstack-mistral-engine.service.erb'),
      require => Package['mistral']
    }

    service { 'openstack-mistral-engine':
      ensure    => running,
      enable    => true,
      require   => File['openstack-mistral-engine'],
      subscribe => File[$::mistral::params::mistral_conf]
    }
  }

  if $is_api {
    notify { 'Start mistral-api': }

    file { 'openstack-mistral-api':
      path    => '/usr/lib/systemd/system/openstack-mistral-api.service',
      owner   => 'mistral',
      group   => 'mistral',
      mode    => '0644',
      content => template('mistral/openstack-mistral-api.service.erb'),
      require => Package['mistral']
    }

    service { 'openstack-mistral-api':
      ensure    => running,
      enable    => true,
      require   => File['openstack-mistral-api'],
      subscribe => File[$::mistral::params::mistral_conf]
    }
  }

  if $is_executor {
    notify { 'Start mistral-executor': }

    file { 'openstack-mistral-executor':
      path    => '/usr/lib/systemd/system/openstack-mistral-executor
      .service',
      owner   => 'mistral',
      group   => 'mistral',
      mode    => '0644',
      content => template('mistral/openstack-mistral-executor.service.erb'),
      require => Package['mistral']
    }

    service { 'openstack-mistral-executor':
      ensure    => running,
      enable    => true,
      require   => File['openstack-mistral-executor'],
      subscribe => File[$::mistral::params::mistral_conf]
    }
  }

  exec { 'update-service':
    command   => $::mistral::params::update_service_command,
    path      => '/usr/bin',
    user      => 'root',
    logoutput => on_failure,
    subscribe => [File['openstack-mistral-executor'],
                  File['openstack-mistral-api'], File['openstack-mistral-engine']]
  }

}
