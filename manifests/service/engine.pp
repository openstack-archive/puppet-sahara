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
# [*periodic_enable*]
#   (Optional) Enable periodic tasks.
#   Defaults to $::os_service_default
#
# [*periodic_fuzzy_delay*]
#   (Optional) Range in seconds to randomly delay when starting the periodic
#   task scheduler to reduse stampending.
#   Defaults to $::os_service_default
#
# [*periodic_interval_max*]
#   (Optional) Max interval size between periodic tasks execution in seconds.
#   Defaults to $::os_service_default
#
# [*min_transient_cluster_active_time*]
#   (Optional) Minimal "lifetime" in seconds for a transient cluster.
#   Defaults to $::os_service_default
#
# [*cleanup_time_for_incomplete_clusters*]
#   (Optional) Maximal time (in hours) for clusters allowed to be in states
#   other than "Active", "Deleting" or "Error".
#   Defaults to $::os_service_default
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
# [*coordinator_heartbeat_interval*]
#   (Optional) Interval size between heartbeat execution in seconds.
#   Defaults to $::os_service_default
#
# [*hash_ring_replicas_count*]
#   (Optional) Number of points that belongs to each number on a hash ring.
#   Defaults to $::os_service_default
#
class sahara::service::engine (
  $enabled                              = true,
  $manage_service                       = true,
  $package_ensure                       = 'present',
  $periodic_enable                      = $::os_service_default,
  $periodic_fuzzy_delay                 = $::os_service_default,
  $periodic_interval_max                = $::os_service_default,
  $min_transient_cluster_active_time    = $::os_service_default,
  $cleanup_time_for_incomplete_clusters = $::os_service_default,
  $periodic_coordinator_backend_url     = $::os_service_default,
  $periodic_workers_number              = $::os_service_default,
  $coordinator_heartbeat_interval       = $::os_service_default,
  $hash_ring_replicas_count             = $::os_service_default,
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
    'DEFAULT/periodic_enable':                      value => $periodic_enable;
    'DEFAULT/periodic_fuzzy_delay':                 value => $periodic_fuzzy_delay;
    'DEFAULT/periodic_interval_max':                value => $periodic_interval_max;
    'DEFAULT/min_transient_cluster_active_time':    value => $min_transient_cluster_active_time;
    'DEFAULT/cleanup_time_for_incomplete_clusters': value => $cleanup_time_for_incomplete_clusters;
    'DEFAULT/periodic_coordinator_backend_url':     value => $periodic_coordinator_backend_url;
    'DEFAULT/periodic_workers_number':              value => $periodic_workers_number;
    'DEFAULT/coordinator_heartbeat_interval':       value => $coordinator_heartbeat_interval;
    'DEFAULT/hash_ring_replicas_count':             value => $hash_ring_replicas_count;
  }
}
