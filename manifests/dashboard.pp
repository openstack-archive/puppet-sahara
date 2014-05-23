# Copyright 2013 Zuercher Hochschule fuer Angewandte Wissenschaften
# All Rights Reserved.
#
#    Licensed under the Apache License, Version 2.0 (the "License"); you may
#    not use this file except in compliance with the License. You may obtain
#    a copy of the License at
#
#         http://www.apache.org/licenses/LICENSE-2.0
#
#    Unless required by applicable law or agreed to in writing, software
#    distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
#    WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
#    License for the specific language governing permissions and limitations
#    under the License.

#
# Used to install sahara's horizon component
#

class sahara::dashboard (
  $sahara_host = '127.0.0.1',
  $sahara_port = '8386',
  $use_neutron = false,
  ) {

  include sahara::params

  if use_neutron {
    $neutron = 'True'
  } else {
    $neutron = 'False'
  }

  if !defined(Package['python-pip']) {
    package { 'python-pip': ensure => latest, }
  }

  if $sahara::params::development {
    info('Installing the developement version of sahara dashboard')

    package { 'sahara-dashboard':
      ensure   => installed,
      provider => pip,
      source   => $sahara::params::development_dashboard_build_url,
      require  => Package['python-pip'],
    }
  } elsif $sahara::params::rpm_install {
      info('Installing RPM package of Sahara-dashboard')
      package { $sahara::params::rpm_package_name_dashboard:
        ensure  => installed,
      }
  } else {
      package { 'sahara-dashboard':
        ensure   => installed,
        provider => pip,
        require  => Package['python-pip'],
      }
  }

  exec { 'sahara-horizon-config':
    command => "echo \"HORIZON_CONFIG['dashboards'] += ('sahara',)\" >> ${sahara::params::horizon_settings}",
    path    => '/usr/bin:/usr/sbin:/bin:/usr/local/bin',
    unless  => "grep \"HORIZON_CONFIG\['dashboards'\] +=\" ${sahara::params::horizon_settings}",
  }

  exec { 'sahara-installed-apps':
    command => "echo \"INSTALLED_APPS += ('saharadashboard',)\" >> ${sahara::params::horizon_settings}",
    path    => '/usr/bin:/usr/sbin:/bin:/usr/local/bin',
    unless  => "grep \"INSTALLED_APPS +=\" ${sahara::params::horizon_settings}",
  }

  exec { 'sahara-use-neutron':
    command => "echo 'SAHARA_USE_NEUTRON = ${neutron}' >> ${sahara::params::horizon_local_settings}",
    path    => '/usr/bin:/usr/sbin:/bin:/usr/local/bin',
    unless  => "grep \"SAHARA_USE_NEUTRON\" ${sahara::params::horizon_local_settings}",
  }

  exec { 'sahara-url':
    command => "echo \"SAHARA_URL = 'http://${sahara_host}:${sahara_port}/v1.1'\" >> ${sahara::params::horizon_local_settings}",
    path    => '/usr/bin:/usr/sbin:/bin:/usr/local/bin',
    unless  => "grep \"SAHARA_URL\" ${sahara::params::horizon_local_settings}",
  }
}