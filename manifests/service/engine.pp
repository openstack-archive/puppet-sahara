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
# [*periodic_coordinator_backend_url*]
#   (Optional) The backend URL to use for distributed periodic tasks
#   coordination.
#   Defaults to $::os_service_default
#
# [*periodic_workers_number*]
#   (Optional) Number of threads to run periodic tasks.
#   Defaults to $::os_service_default
#
class sahara::service::engine (
  $enabled                          = true,
  $manage_service                   = true,
  $package_ensure                   = 'present',
  $periodic_coordinator_backend_url = $::os_service_default,
  $periodic_workers_number          = $::os_service_default,
) {

  include sahara::deps
  include sahara::params

  package { 'sahara-engine':
    ensure => $package_ensure,
    name   => $::sahara::params::engine_package_name,
    tag    => ['openstack', 'sahara-package'],
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
    tag        => 'sahara-service',
  }

  oslo::coordination{ 'sahara_config':
    backend_url   => $periodic_coordinator_backend_url,
    manage_config => false
  }

  sahara_config {
    'DEFAULT/periodic_coordinator_backend_url': value => $periodic_coordinator_backend_url;
    'DEFAULT/periodic_workers_number':          value => $periodic_workers_number;
  }
}
