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

class savanna::install {
  include savanna::params

  # this is here until this fix is released
  # https://bugs.launchpad.net/ubuntu/+source/python-pbr/+bug/1245676
  if !defined(Package['git']) {
    package { 'python-pip': ensure => latest, }
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

  if $savanna::params::development {
    info("Installing and using the savanna development version. URL:
      ${savanna::params::development_build_url}")

    exec { 'savanna':
      command => "pip install ${savanna::params::development_build_url}",
      path    => '/usr/bin:/usr/sbin:/bin:/usr/local/bin',
      unless  => 'stat /usr/local/lib/python2.7/dist-packages/savanna',
      require => Package['python-pip'],
    }
  } else {
    package { 'savanna':
      ensure   => installed,
      provider => pip,
      require  => Package['python-pip'],
    }
  }

  group { 'savanna':
    ensure => present,
    system => true,
  } ->
  user { 'savanna':
    ensure => present,
    gid    => 'savanna',
    system => true,
    home   => '/var/lib/savanna',
    shell  => '/bin/false'
  } ->
  file { '/var/lib/savanna':
    ensure => 'directory',
    owner  => 'savanna',
    group  => 'savanna',
    mode   => '0750',
  } ->
  file { '/var/log/savanna':
    ensure => 'directory',
    owner  => 'savanna',
    group  => 'savanna',
    mode   => '0750',
  } ->
  file { '/var/log/savanna/savanna.log':
    ensure => 'file',
    owner  => 'savanna',
    group  => 'savanna',
    mode   => '0640',
  } ->
  file { '/etc/savanna':
    ensure => 'directory',
    owner  => 'savanna',
    group  => 'savanna',
    mode   => '0750',
  } ->
  file { '/etc/savanna/savanna.conf':
    ensure  => file,
    path    => '/etc/savanna/savanna.conf',
    content => template('savanna/savanna.conf.erb'),
    owner   => 'savanna',
    group   => 'savanna',
    mode    => '0640',
  }

  if $::osfamily == 'Debian' {
    file { '/etc/init.d/savanna-api':
      ensure  => file,
      path    => '/etc/init.d/savanna-api',
      content => template('savanna/savanna-api.erb'),
      mode    => '0750',
      owner   => 'root',
      group   => 'root',
    } ->
    file { '/etc/savanna/savanna-api.conf':
      ensure  => file,
      path    => '/etc/init/savanna-api.conf',
      content => template('savanna/savanna-api.conf.erb'),
      mode    => '0750',
      owner   => 'root',
      group   => 'root',
      notify  => Service['savanna-api'],
    }
  } else {
    error('Savanna cannot be installed on this operating system.
          It does not have the supported initscripts. There is only
          support for Debian-based systems.')
  }
}