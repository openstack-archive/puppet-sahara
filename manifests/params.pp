# == Class: sahara::params
#
# Parameters for puppet-sahara
#
class sahara::params {
  include ::openstacklib::defaults
  $pyvers = $::openstacklib::defaults::pyvers

  $client_package_name = "python${pyvers}-saharaclient"
  $group               = 'sahara'

  case $::osfamily {
    'RedHat': {
      $common_package_name       = 'openstack-sahara-common'
      $all_package_name          = 'openstack-sahara'
      $api_package_name          = 'openstack-sahara-api'
      $engine_package_name       = 'openstack-sahara-engine'
      # TODO(tobias-urdin): Remove this when deprecated sahara-all service is removed.
      $all_service_name          = 'openstack-sahara-all'
      $api_service_name          = 'openstack-sahara-api'
      $engine_service_name       = 'openstack-sahara-engine'
      $sahara_wsgi_script_path   = '/var/www/cgi-bin/sahara'
      $sahara_wsgi_script_source = '/usr/bin/sahara-wsgi-api'
    }
    'Debian': {
      $common_package_name       = 'sahara-common'
      $all_package_name          = 'sahara'
      $api_package_name          = 'sahara-api'
      $engine_package_name       = 'sahara-engine'
      $all_service_name          = 'sahara'
      $api_service_name          = 'sahara-api'
      $engine_service_name       = 'sahara-engine'
      $sahara_wsgi_script_path   = '/usr/lib/cgi-bin/sahara'
      $sahara_wsgi_script_source = '/usr/bin/sahara-wsgi-api'
    }
    default: {
      fail("Unsupported osfamily: ${::osfamily} operatingsystem: ${::operatingsystem}")
    }
  }
}
