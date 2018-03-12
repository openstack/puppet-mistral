#
# Class to execute "mistral-db-manage 'upgrade head' and 'populate'"
#
class mistral::db::sync {

  include ::mistral::deps
  include ::mistral::params

  exec { 'mistral-db-sync':
    command     => $::mistral::params::db_sync_command,
    path        => '/usr/bin',
    user        => 'mistral',
    logoutput   => on_failure,
    refreshonly => true,
    try_sleep   => 5,
    tries       => 10,
    subscribe   => [
      Anchor['mistral::install::end'],
      Anchor['mistral::config::end'],
      Anchor['mistral::dbsync::begin']
    ],
    notify      => Anchor['mistral::dbsync::end'],
    tag         => 'openstack-db',
  }

  exec { 'mistral-db-populate':
    require     => Exec['mistral-db-sync'],
    command     => $::mistral::params::db_populate_command,
    path        => '/usr/bin',
    user        => 'mistral',
    logoutput   => on_failure,
    refreshonly => true,
    subscribe   => [
      Anchor['mistral::install::end'],
      Anchor['mistral::config::end'],
      Anchor['mistral::dbsync::begin']
    ],
    notify      => Anchor['mistral::dbsync::end'],
    tag         => 'openstack-db',
  }

}
