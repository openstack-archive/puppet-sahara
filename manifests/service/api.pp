# == Class: sahara::service::api
#
# Installs & configure the Sahara API service
#
# === Parameters
#
# [*api_workers*]
#   (Optional) Number of workers for Sahara API service
#   0 means all-in-one-thread configuration
#   Defaults to 0
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
class sahara::service::api (
  $api_workers    = 0,
  $enabled        = true,
  $manage_service = true,
  $package_ensure = 'present',
) {

  include ::sahara

  Sahara_config<||> ~> Service['sahara-api']
  # degorenko: Line below (and include instead of require) is workarounds
  # for bugs 1452698 and 1450945. It will be deleted after fix in package
  Package<|title == 'sahara-common' |> -> Package['sahara-api']
  Class['sahara::policy'] ~> Service['sahara-api']

  package { 'sahara-api':
    ensure => $package_ensure,
    name   => $::sahara::params::api_package_name,
    tag    => ['openstack', 'sahara-package'],
    notify => Service['sahara-api'],
  }

  sahara_config {
    'DEFAULT/api_workers': value => $api_workers;
  }

  if $manage_service {
    if $enabled {
      $service_ensure = 'running'
    } else {
      $service_ensure = 'stopped'
    }
  }

  service { 'sahara-api':
    ensure     => $service_ensure,
    name       => $::sahara::params::api_service_name,
    enable     => $enabled,
    hasstatus  => true,
    hasrestart => true,
    require    => Package['sahara-api'],
    tag        => 'sahara-service',
  }

}
