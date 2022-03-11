require 'puppet/util/inifile'
require 'puppet/provider/openstack/auth'
require 'puppet/provider/openstack/credentials'
require File.join(File.dirname(__FILE__), '..','..', 'puppet/provider/mistral_workflow_requester')

class Puppet::Provider::Mistral < Puppet::Provider::MistralWorkflowRequester

  extend Puppet::Provider::Openstack::Auth

  def self.request(service, action, properties=nil)
    begin
      super
    rescue Puppet::Error::OpenstackAuthInputError, Puppet::Error::OpenstackUnauthorizedError => error
      mistral_request(service, action, error, properties)
    end
  end

  def self.mistral_request(service, action, error, properties=nil)
    warning('Usage of keystone_authtoken parameters is deprecated.')
    properties ||= []
    @credentials.username = mistral_credentials['username']
    @credentials.password = mistral_credentials['password']
    @credentials.project_name = mistral_credentials['project_name']
    @credentials.auth_url = auth_endpoint
    if mistral_credentials['region_name']
      @credentials.region_name = mistral_credentials['region_name']
    end
    if @credentials.version == '3'
      @credentials.user_domain_name = mistral_credentials['user_domain_name']
      @credentials.project_domain_name = mistral_credentials['project_domain_name']
    end
    raise error unless @credentials.set?

    if action == 'create'
      mistral_create_request(action, properties)
    else
      Puppet::Provider::Openstack.request(service, action, properties, @credentials)
    end
  end

  def self.conf_filename
    '/etc/mistral/mistral.conf'
  end

  def self.mistral_conf
    return @mistral_conf if @mistral_conf
    @mistral_conf = Puppet::Util::IniConfig::File.new
    @mistral_conf.read(conf_filename)
    @mistral_conf
  end

  def self.mistral_credentials
    @mistral_credentials ||= get_mistral_credentials
  end

  def mistral_credentials
    self.class.mistral_credentials
  end

  def self.get_mistral_credentials
    auth_keys = ['auth_url', 'project_name', 'username', 'password']
    conf = mistral_conf
    if conf and conf['keystone_authtoken'] and
        auth_keys.all?{|k| !conf['keystone_authtoken'][k].nil?}
      creds = Hash[ auth_keys.map \
                   { |k| [k, conf['keystone_authtoken'][k].strip] } ]

      if conf['project_domain_name']
        creds['project_domain_name'] = conf['project_domain_name']
      else
        creds['project_domain_name'] = 'Default'
      end

      if conf['user_domain_name']
        creds['user_domain_name'] = conf['user_domain_name']
      else
        creds['user_domain_name'] = 'Default'
      end

      if conf['region_name']
        creds['region_name'] = conf['region_name']
      end
      return creds
    else
      raise(Puppet::Error, "File: #{conf_filename} does not contain all " +
            "required authentication options. Mistral types will not work " +
            "if mistral is not correctly configured to use Keystone " +
            "authentication.")
    end
  end

  def self.get_auth_endpoint
    m = mistral_credentials
    "#{m['auth_url']}"
  end

  def self.auth_endpoint
    @auth_endpoint ||= get_auth_endpoint
  end

  def self.reset
    @mistral_conf = nil
    @mistral_credentials = nil
    @auth_endpoint = nil
  end

end
