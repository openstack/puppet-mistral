mistral
======

#### Table of Contents

1. [Overview - What is the mistral module?](#overview)
2. [Module Description - What does the module do?](#module-description)
3. [Setup - The basics of getting started with mistral](#setup)
4. [Implementation - An under-the-hood peek at what the module is doing](#implementation)
5. [Development - Guide for contributing to the module](#development)
6. [Contributors - Those with commits](#contributors)

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
[core of openstack](http://docs.openstack.org) documentation.


Implementation
--------------

### mistral

puppet-mistral is a combination of Puppet manifests and ruby code to deliver
configuration and extra functionality through types and providers.


Development
-----------

Developer documentation for the entire puppet-openstack project.

* https://wiki.openstack.org/wiki/Puppet#Developer_documentation

Contributors
------------

* https://github.com/openstack/puppet-mistral/graphs/contributors
