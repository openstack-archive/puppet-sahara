# == Class: sahara::service::engine
#
# Installs & configure the Sahara Engine service
#
# === Parameters
#
# [*enabled*]
#   (Optional) Should the service be enabled.
#   Defaults to 'true'.
#
# [*manage_service*]
#   (Optional) Whether the service should be managed by Puppet.
#   Defaults to 'true'.
#
# [*package_ensure*]
#   (Optional) Ensure state for package.
#   Defaults to 'present'
#
class sahara::service::engine (
  $enabled        = true,
  $manage_service = true,
  $package_ensure = 'present',
) {

  include ::sahara::params

  Sahara_config<||> ~> Service['sahara-engine']

  package { 'sahara-engine':
    ensure => $package_ensure,
    name   => $::sahara::params::engine_package_name,
    tag    => ['openstack', 'sahara-package'],
    notify => Service['sahara-engine'],
  }

  if $manage_service {
    if $enabled {
      $service_ensure = 'running'
    } else {
      $service_ensure = 'stopped'
    }
  }

  service { 'sahara-engine':
    ensure     => $service_ensure,
    name       => $::sahara::params::engine_service_name,
    enable     => $enabled,
    hasstatus  => true,
    hasrestart => true,
    require    => Package['sahara-engine'],
    tag        => 'sahara-service',
  }

}
