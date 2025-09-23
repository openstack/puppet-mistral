# == Class: mistral::client
#
# Installs mistral python client.
#
# === Parameters
#
# [*package_ensure*]
#   Ensure state for package. Defaults to 'present'.
#
class mistral::client (
  Stdlib::Ensure::Package $package_ensure = present,
) {
  include mistral::deps
  include mistral::params

  package { 'python-mistralclient':
    ensure => $package_ensure,
    name   => $mistral::params::client_package,
    tag    => ['openstack', 'openstackclient'],
  }

  include openstacklib::openstackclient
}
