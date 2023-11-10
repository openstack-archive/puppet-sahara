# == Define: sahara::plugin
#
#  Sahara plugin configuration
#
# === Parameters
#
# [*package_ensure*]
#   (Optional) Ensure state for package
#   Defaults to 'present'.
#
define sahara::plugin(
  $package_ensure = 'present',
) {

  include sahara::deps
  include sahara::params

  package { "sahara-plugin-${name}":
    ensure => $package_ensure,
    name   => "${::sahara::params::plugin_package_name_base}${name}",
    tag    => ['openstack', 'sahara-package'],
  }
}
