# == Class: mistral
#
# Manage mistral-extra package
#
# === Parameters
#
# [*package_ensure*]
#   (Optional) Ensure state for package.
#   Defaults to 'present'.
#
class mistral::extra (
  Stdlib::Ensure::Package $package_ensure = present,
) {
  include mistral::deps
  include mistral::params

  package { 'mistral-extra':
    ensure => $package_ensure,
    name   => $mistral::params::extra_package_name,
    tag    => ['openstack', 'mistral-package'],
  }
}
