#
# Class to execute "mistral-dbsync"
#
class mistral::db::sync {

  exec { 'mistral-dbsync':
    command   => $::mistral::params::dbsync_command,
    path      => '/usr/bin',
    user      => 'mistral',
    logoutput => on_failure,
    subscribe => File[$::mistral::params::mistral_conf],
  }

  Exec['mistral-dbsync'] ~> Service<| title == 'mistral' |>
}
