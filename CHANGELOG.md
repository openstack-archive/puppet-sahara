## 8.0.0 and beyond

From 8.0.0 release and beyond, release notes are published on
[docs.openstack.org](http://docs.openstack.org/releasenotes/puppet-sahara/).

##2015-11-25 - 7.0.0
###Summary

This is a backwards-incompatible major release for OpenStack Liberty.

####Backwards-incompatible changes
- remove kilo deprecated parameters

####Features
- add distribute mode support
- introduce Sahara extended logging class
- remove POSIX file modes
- add tag to package and service resources
- add sahara::config class
- add sahara::db::sync
- add support of SSL
- add an ability to manage use_stderr parameter
- reflect provider change in puppet-openstacklib
- introduce sahara::db class
- db: use postgresql lib class for psycopg package
- add new parameter 'plugins' for Sahara
- configure rpc options separately from ceilometer notifications

####Bugfixes
- rely on autorequire for config resource ordering
- remove Sqlite validation for database_connection

####Maintenance
- initial msync run for all Puppet OpenStack modules
- try to use zuul-cloner to prepare fixtures
- remove class_parameter_defaults puppet-lint check
- acceptance: use common bits from puppet-openstack-integration

##2015-10-10 - 6.1.0
###Summary

This is a maintenance and features release in the Kilo series.

####Features
- Update parameters for Sahara

####Maintenance
- acceptance: checkout stable/kilo puppet modules

##2015-07-08 - 6.0.0
###Summary

- Initial release of the puppet-sahara module
