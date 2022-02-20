#
# Class to execute "mistral-db-manage 'upgrade head' and 'populate'"
#
# ==Parameters
#
# [*db_sync_timeout*]
#   (Optional) Timeout for the execution of the db_sync
#   Defaults to 300
#
class mistral::db::sync(
  $db_sync_timeout = 300,
) {

  include mistral::deps
  include mistral::params

  exec { 'mistral-db-sync':
    command     => $::mistral::params::db_sync_command,
    path        => '/usr/bin',
    user        => $::mistral::params::user,
    logoutput   => on_failure,
    refreshonly => true,
    try_sleep   => 5,
    tries       => 10,
    timeout     => $db_sync_timeout,
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
    user        => $::mistral::params::user,
    timeout     => $db_sync_timeout,
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
