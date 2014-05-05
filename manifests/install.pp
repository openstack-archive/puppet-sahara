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

class sahara::install {
  include sahara::params

  # this is here until this fix is released
  # https://bugs.launchpad.net/ubuntu/+source/python-pbr/+bug/1245676
  if !defined(Package['git']) {
    package { 'git': ensure => latest, }
  }

  if !defined(Package['python-pip']) {
    package { 'python-pip':
      ensure  => latest,
      require => Package['git']
    }
  }

  if !defined(Package['python-dev']) {
    package { 'python-dev':
      ensure  => latest,
      require => Package['python-pip']
    }
  }

  if $sahara::params::development {
    info("Installing and using the sahara development version. URL:
      ${sahara::params::development_build_url}")

    package { 'sahara':
      ensure   => installed,
      provider => pip,
      source   => $sahara::params::development_build_url,
      require  => Package['python-pip'],
    }
  } else {
    package { 'sahara':
      ensure   => installed,
      provider => pip,
      require  => Package['python-pip'],
    }
  }

  group { 'sahara':
    ensure => present,
    system => true,
  } ->
  user { 'sahara':
    ensure => present,
    gid    => 'sahara',
    system => true,
    home   => '/var/lib/sahara',
    shell  => '/bin/false'
  } ->
  file { '/var/lib/sahara':
    ensure => 'directory',
    owner  => 'sahara',
    group  => 'sahara',
    mode   => '0750',
  } ->
  file { '/var/log/sahara':
    ensure => 'directory',
    owner  => 'sahara',
    group  => 'sahara',
    mode   => '0750',
  } ->
  file { '/var/log/sahara/sahara.log':
    ensure => 'file',
    owner  => 'sahara',
    group  => 'sahara',
    mode   => '0640',
  } ->
  file { '/etc/sahara':
    ensure => 'directory',
    owner  => 'sahara',
    group  => 'sahara',
    mode   => '0750',
  } ->
  file { '/etc/sahara/sahara.conf':
    ensure  => file,
    path    => '/etc/sahara/sahara.conf',
    content => template('sahara/sahara.conf.erb'),
    owner   => 'sahara',
    group   => 'sahara',
    mode    => '0640',
  }

  if $::osfamily == 'Debian' {
    file { '/etc/init.d/sahara-api':
      ensure  => file,
      path    => '/etc/init.d/sahara-api',
      content => template('sahara/sahara-api.erb'),
      mode    => '0750',
      owner   => 'root',
      group   => 'root',
    } ->
    file { '/etc/sahara/sahara-api.conf':
      ensure  => file,
      path    => '/etc/init/sahara-api.conf',
      content => template('sahara/sahara-api.conf.erb'),
      mode    => '0750',
      owner   => 'root',
      group   => 'root',
      notify  => Service['sahara-api'],
    }
  } else {
    error('Sahara cannot be installed on this operating system.
          It does not have the supported initscripts. There is only
          support for Debian-based systems.')
  }
}