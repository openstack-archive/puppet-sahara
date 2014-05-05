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
# Used to grant access to the sahara mysql DB
#

define sahara::db::mysql::host_access ($user, $password, $database) {
  database_user { "${user}@${name}":
    password_hash => mysql_password($password),
    provider      => 'mysql',
    require       => Database[$database],
  }

  database_grant { "${user}@${name}/${database}":
    # TODO figure out which privileges to grant.
    privileges => 'all',
    provider   => 'mysql',
    require    => Database_user["${user}@${name}"]
  }
}
