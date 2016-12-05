# == Class: mistral::db::postgresql
#
# Class that configures postgresql for mistral
# Requires the Puppetlabs postgresql module.
#
# === Parameters
#
# [*password*]
#   (Required) Password to connect to the database.
#
# [*dbname*]
#   (Optional) Name of the database.
#   Defaults to 'mistral'.
#
# [*user*]
#   (Optional) User to connect to the database.
#   Defaults to 'mistral'.
#
#  [*encoding*]
#    (Optional) The charset to use for the database.
#    Default to undef.
#
#  [*privileges*]
#    (Optional) Privileges given to the database user.
#    Default to 'ALL'
#
# == Dependencies
#
# == Examples
#
# == Authors
#
# == Copyright
#
class mistral::db::postgresql(
  $password,
  $dbname     = 'mistral',
  $user       = 'mistral',
  $encoding   = undef,
  $privileges = 'ALL',
) {

  include ::mistral::deps

  ::openstacklib::db::postgresql { 'mistral':
    password_hash => postgresql_password($user, $password),
    dbname        => $dbname,
    user          => $user,
    encoding      => $encoding,
    privileges    => $privileges,
  }

  Anchor['mistral::db::begin']
  ~> Class['mistral::db::postgresql']
  ~> Anchor['mistral::db::end']
}
