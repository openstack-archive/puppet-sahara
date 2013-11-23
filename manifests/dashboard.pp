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
# Used to install savanna's horizon component
#

class savanna::dashboard (
  $savanna_host = '127.0.0.1',
  $savanna_port = '8386',
  $use_neutron = false,
  ) {

  include savanna::params

  if use_neutron {
    $neutron = 'True'
  } else {
    $neutron = 'False'
  }

  if !defined(Package['python-pip']) {
    package { 'python-pip': ensure => latest, }
  }

  if $savanna::params::development {
    info('Installing the developement version of savanna dashboard')

    exec { 'savannadashboard':
      command => "pip install ${::savanna::params::development_dashboard_build_url}",
      path    => '/usr/bin:/usr/sbin:/bin:/usr/local/bin',
      unless  => 'stat /usr/local/lib/python2.7/dist-packages/savannadashboard',
      require => Package['python-pip'],
    }
  } else {
    package { 'savanna-dashboard':
      ensure   => installed,
      provider => pip,
      require  => Package['python-pip'],
    }
  }

  exec { 'savanna-horizon-config':
    command => "echo \"HORIZON_CONFIG['dashboards'] += ('savanna',)\" >> ${savanna::params::horizon_settings}",
    path    => '/usr/bin:/usr/sbin:/bin:/usr/local/bin',
    unless  => "grep \"HORIZON_CONFIG\['dashboards'\] +=\" ${savanna::params::horizon_settings}",
    require => Package['savanna-dashboard'],
  }

  exec { 'savanna-installed-apps':
    command => "echo \"INSTALLED_APPS += ('savannadashboard',)\" >> ${savanna::params::horizon_settings}",
    path    => '/usr/bin:/usr/sbin:/bin:/usr/local/bin',
    unless  => "grep \"INSTALLED_APPS +=\" ${savanna::params::horizon_settings}",
    require => Package['savanna-dashboard'],
  }

  exec { 'savanna-use-neutron':
    command => "echo 'SAVANNA_USE_NEUTRON = ${neutron}' >> ${savanna::params::horizon_local_settings}",
    path    => '/usr/bin:/usr/sbin:/bin:/usr/local/bin',
    unless  => "grep \"SAVANNA_USE_NEUTRON\" ${savanna::params::horizon_local_settings}",
    require => Package['savanna-dashboard'],
  }

  exec { 'savanna-url':
    command => "echo \"SAVANNA_URL = 'http://${savanna_host}:${savanna_port}/v1.1'\" >> ${savanna::params::horizon_local_settings}",
    path    => '/usr/bin:/usr/sbin:/bin:/usr/local/bin',
    unless  => "grep \"SAVANNA_URL\" ${savanna::params::horizon_local_settings}",
    require => Package['savanna-dashboard'],
  }
}