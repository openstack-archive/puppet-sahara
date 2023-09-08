Team and repository tags
========================

[![Team and repository tags](https://governance.openstack.org/tc/badges/puppet-sahara.svg)](https://governance.openstack.org/tc/reference/tags/index.html)

<!-- Change things from this point on -->

sahara
======

#### Table of Contents

1. [Overview - What is the sahara module?](#overview)
2. [Module Description - What does the module do?](#module-description)
3. [Setup - The basics of getting started with sahara](#setup)
4. [Implementation - An under-the-hood peek at what the module is doing](#implementation)
5. [Limitations - OS compatibility, etc.](#limitations)
6. [Development - Guide for contributing to the module](#development)
7. [Contributors - Those with commits](#contributors)
8. [Release Notes - Release notes for the project](#release-notes)
9. [Repository - The project source code repository](#repository)

Overview
--------

The sahara module is a part of [OpenStack](https://opendev.org/openstack), an effort
by the OpenStack infrastructure team to provide continuous integration testing and
code review for OpenStack and OpenStack community projects as part of the core software.
The Sahara module itself is used to flexibly configure and manage the clustering service for OpenStack.

Module Description
------------------

The sahara module is an attempt to make Puppet capable of managing the
entirety of sahara.

Setup
-----

**What the sahara module affects:**

* [Sahara](https://docs.openstack.org/sahara/latest/), the data processing service for OpenStack.

### Installing Sahara

    puppet module install openstack/sahara

### Beginning with sahara

To use the sahara module's functionality you will need to declare multiple
resources.  This is not an exhaustive list of all the components needed; we
recommend you consult and understand the
[core of openstack](https://docs.openstack.org) documentation.

Examples of usage can be found in the *examples* directory.

Implementation
--------------

### sahara

puppet-sahara is a combination of Puppet manifests and ruby code to deliver
configuration and extra functionality through types and providers.

### Types

#### sahara_config

The `sahara_config` provider is a children of the ini_setting provider. It allows one to write an entry in the `/etc/sahara/sahara.conf` file.

```puppet
sahara_config { 'DEFAULT/use_neutron' :
  value => True,
}
```

This will write `use_neutron=True` in the `[DEFAULT]` section.

##### name

Section/setting name to manage from `sahara.conf`

##### value

The value of the setting to be defined.

##### secret

Whether to hide the value from Puppet logs. Defaults to `false`.

##### ensure_absent_val

If value is equal to ensure_absent_val then the resource will behave as if `ensure => absent` was specified. Defaults to `<SERVICE DEFAULT>`

Limitations
-----------

None.

Development
-----------

Developer documentation for the entire puppet-openstack project.

* https://docs.openstack.org/puppet-openstack-guide/latest/

Contributors
------------

* https://github.com/openstack/puppet-sahara/graphs/contributors

Release Notes
-------------

* https://docs.openstack.org/releasenotes/puppet-sahara

Repository
----------

* https://opendev.org/openstack/puppet-sahara
