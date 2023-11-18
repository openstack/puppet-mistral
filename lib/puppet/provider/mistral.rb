require 'puppet/provider/openstack/auth'
require 'puppet/provider/openstack/credentials'
require File.join(File.dirname(__FILE__), '..','..', 'puppet/provider/mistral_workflow_requester')

class Puppet::Provider::Mistral < Puppet::Provider::MistralWorkflowRequester

  extend Puppet::Provider::Openstack::Auth

end
