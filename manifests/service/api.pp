# == Class: sahara::service::api
#
# Installs & configure the Sahara API service
#
# === Parameters
#
# [*api_workers*]
#   (Optional) Number of workers for Sahara API service
#   0 means all-in-one-thread configuration
#   Defaults to $::os_workers
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
# [*service_name*]
#   (Optional) Name of the service that will be providing the
#   server functionality of sahara-api.
#   If the value is 'httpd', this means sahara-api will be a web
#   service, and you must use another class to configure that
#   web service. For example, use class { 'sahara::wsgi::apache'...}
#   to make sahara-api be a web app using apache mod_wsgi.
#   Defaults to '$::sahara::params::api_service_name'
#
class sahara::service::api (
  $api_workers    = $::os_workers,
  $enabled        = true,
  $manage_service = true,
  $package_ensure = 'present',
  $service_name   = $::sahara::params::api_service_name,
) inherits ::sahara::params {

  include ::sahara::deps
  include ::sahara::policy

  if $::operatingsystem == 'Ubuntu' and $service_name == $::sahara::params::api_service_name {
    fail('The Sahara API must be run with WSGI on Ubuntu')
  }

  package { 'sahara-api':
    ensure => $package_ensure,
    name   => $::sahara::params::api_package_name,
    tag    => ['openstack', 'sahara-package'],
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

  if $service_name == $::sahara::params::api_service_name {
    service { 'sahara-api':
      ensure     => $service_ensure,
      name       => $::sahara::params::api_service_name,
      enable     => $enabled,
      hasstatus  => true,
      hasrestart => true,
      tag        => 'sahara-service',
    }
  } elsif $service_name == 'httpd' {
    include ::apache::params

    if $::operatingsystem != 'Ubuntu' {
      service { 'sahara-api':
        ensure => 'stopped',
        name   => $::sahara::params::api_service_name,
        enable => false,
        tag    => 'sahara-service',
      }
      Service['sahara-api'] -> Service[$service_name]
    }
    Service<| title == 'httpd' |> { tag +> 'sahara-service' }
  }
}
