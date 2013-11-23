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

class savanna::params {
  $sys_rundir = '/var/run'
  $savanna_service = 'savanna-api'
  $savanna_logdir = '/var/log/savanna'
  $savanna_rundir = '/var/run/savanna'
  $savanna_lockdir = '/var/lock/savanna'
  $savanna_conf_file = '/etc/savanna/savanna.conf'
  $savanna_syslog = false
  $savanna_usefips = false
  $savanna_node_domain = 'novalocal'
  # installs source version from github builds
  $development = false
  $development_build_url =
    'http://tarballs.openstack.org/savanna/savanna-master.tar.gz'
  $development_dashboard_build_url =
  'http://tarballs.openstack.org/savanna-dashboard/savanna-dashboard-master.tar.gz'

  # these two paths are OS specific - on redhat they're diff
  $horizon_settings =
    '/usr/share/openstack-dashboard/openstack_dashboard/settings.py'
  $horizon_local_settings =
    '/usr/share/openstack-dashboard/openstack_dashboard/local/local_settings.py'
}
