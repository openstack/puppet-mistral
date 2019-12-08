# == Class: mistral::client
#
# Installs mistral python client.
#
# === Parameters
#
# [*package_ensure*]
#   Ensure state for package. Defaults to 'present'.
#
class mistral::client(
  $package_ensure = 'present'
) {

  include mistral::deps
  include mistral::params

  package { 'python-mistralclient':
    ensure => $package_ensure,
    name   => $::mistral::params::client_package,
    tag    => ['openstack', 'mistral-package'],
  }

  include '::openstacklib::openstackclient'
}
