Team and repository tags
========================

[![Team and repository tags](https://governance.openstack.org/tc/badges/puppet-mistral.svg)](https://governance.openstack.org/tc/reference/tags/index.html)

<!-- Change things from this point on -->

mistral
======

#### Table of Contents

1. [Overview - What is the mistral module?](#overview)
2. [Module Description - What does the module do?](#module-description)
3. [Setup - The basics of getting started with mistral](#setup)
4. [Implementation - An under-the-hood peek at what the module is doing](#implementation)
5. [Limitations - OS compatibility, etc.](#limitations)
6. [Development - Guide for contributing to the module](#development)
7. [Contributors - Those with commits](#contributors)
8. [Release Notes - Release notes for the project](#release-notes)
9. [Repository - The project source code repository](#repository)

Overview
--------

The Mistral module itself is a workflow service for OpenStack cloud.

Module Description
------------------

The mistral module is an attempt to make Puppet capable of managing the
entirety of mistral.

Setup
-----

### Beginning with mistral

To use the mistral module's functionality you will need to declare multiple
resources.  This is not an exhaustive list of all the components needed; we
recommend you consult and understand the
[Mistral](https://docs.openstack.org/mistral/latest/) documentation.


Implementation
--------------

### Mistral

puppet-mistral is a combination of Puppet manifests and ruby code to deliver
configuration and extra functionality through types and providers.

### Types

#### mistral_config

The `mistral_config` provider is a children of the ini_setting provider. It allows one to write an entry in the `/etc/mistral/mistral.conf` file.

```puppet
mistral_config { 'DEFAULT/use_syslog' :
  value => false,
}
```

This will write `use_syslog=false` in the `[DEFAULT]` section.

##### name

Section/setting name to manage from `mistral.conf`

##### value

The value of the setting to be defined.

##### secret

Whether to hide the value from Puppet logs. Defaults to `false`.

##### ensure_absent_val

If value is equal to ensure_absent_val then the resource will behave as if `ensure => absent` was specified. Defaults to `<SERVICE DEFAULT>`

### mistral_workflow

The `mistral_workflow` provider allows the creation/update/deletion of workflow definitions using a source file (in YAML).

```puppet
mistral_workflow { 'my_workflow':
  ensure          => present,
  definition_file => '/home/user/my_workflow.yaml',
  is_public       => true,
}
```

Or:

```puppet
mistral_workflow { 'my_workflow':
  ensure => absent,
}
```

If you need to force the update of the workflow or change it's public attribute, use `latest`:
```puppet
mistral_workflow { 'my_workflow':
  ensure          => latest,
  definition_file => '/home/user/my_workflow.yaml',
  is_public       => false,
}
```

Although the mistral client allows multiple workflow definitions per source file, it not recommended to do so with this provider as the `mistral_workflow` is supposed to represent a single workflow.

#### name

The name of the workflow; this is only used when deleting the workflow since the definition file specifies the name of the workflow to create/update.

#### definition_file

The path to the file containing the definition of the workflow. This parameter is not mandatory but the creation or update will fail if it is not supplied.

#### is_public

Specifies whether the workflow must be public or not. Defaults to `true`.

Limitations
------------

* All the mistral types use the CLI tools and so need to be ran on the mistral node.

Beaker-Rspec
------------

This module has beaker-rspec tests

To run:

```shell
bundle install
bundle exec rspec spec/acceptance
```

Development
-----------

Developer documentation for the entire puppet-openstack project.

* https://docs.openstack.org/puppet-openstack-guide/latest/

Contributors
------------

* https://github.com/openstack/puppet-mistral/graphs/contributors

Release Notes
-------------

* https://docs.openstack.org/releasenotes/puppet-mistral

Repository
----------

* https://git.openstack.org/cgit/openstack/puppet-mistral
