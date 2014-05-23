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
# Used to setup the sahara keystone user
#

class sahara::keystone::auth (
  $password = 'sahara',
  $auth_name = 'sahara',
  $email = 'sahara@localhost',
  $tenant = 'services',
  $configure_endpoint = true,
  $service_type = 'data_processing',
  $public_address = '127.0.0.1',
  $admin_address = '127.0.0.1',
  $internal_address = '127.0.0.1',
  $port = '8386',
  $public_port = undef,
  $region = 'RegionOne',
  $public_protocol = 'http',
  $internal_protocol = 'http',
  ) {

  Keystone_user_role["${auth_name}@${tenant}"] ~>
    Service <| name == 'sahara-api' |>

  if !$public_port {
    $real_public_port = $port
  } else {
    $real_public_port = $public_port
  }

  keystone_user { $auth_name:
    ensure   => present,
    password => $password,
    email    => $email,
    tenant   => $tenant,
  }

  keystone_user_role { "${auth_name}@${tenant}":
    ensure => present,
    roles  => 'admin',
  }

  keystone_service { $auth_name:
    ensure      => present,
    type        => $service_type,
    description => 'Openstack Data Processing',
  }

  if $configure_endpoint {
    keystone_endpoint { "${region}/${auth_name}":
      ensure       => present,
      public_url   =>
        "${public_protocol}://${public_address}:${real_public_port}/",
      internal_url => "${internal_protocol}://${internal_address}:${port}/",
      admin_url    => "${internal_protocol}://${admin_address}:${port}/",
    }
  }
}