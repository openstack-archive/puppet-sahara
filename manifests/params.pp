# == Class: sahara::params
#
# Parameters for puppet-sahara
#
class sahara::params {
  include openstacklib::defaults

  $client_package_name = 'python3-saharaclient'
  $group               = 'sahara'

  case $::osfamily {
    'RedHat': {
      $common_package_name       = 'openstack-sahara-common'
      $api_package_name          = 'openstack-sahara-api'
      $engine_package_name       = 'openstack-sahara-engine'
      $api_service_name          = 'openstack-sahara-api'
      $engine_service_name       = 'openstack-sahara-engine'
      $sahara_wsgi_script_path   = '/var/www/cgi-bin/sahara'
      $sahara_wsgi_script_source = '/usr/bin/sahara-wsgi-api'
    }
    'Debian': {
      $common_package_name       = 'sahara-common'
      $api_package_name          = 'sahara-api'
      $engine_package_name       = 'sahara-engine'
      $api_service_name          = 'sahara-api'
      $engine_service_name       = 'sahara-engine'
      $sahara_wsgi_script_path   = '/usr/lib/cgi-bin/sahara'
      $sahara_wsgi_script_source = '/usr/bin/sahara-wsgi-api'
    }
    default: {
      fail("Unsupported osfamily: ${::osfamily} operatingsystem: ${::operatingsystem}, \
module ${module_name} only support osfamily RedHat and Debian")
    }
  }
}
