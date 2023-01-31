require 'puppet'
require 'spec_helper'
require 'puppet/provider/mistral'
require 'tempfile'

klass = Puppet::Provider::Mistral

describe Puppet::Provider::Mistral do

  after :each do
    klass.reset
  end

  describe 'when retrieving the auth credentials' do

    it 'should fail if no auth params are passed and the mistral config file does not have the expected contents' do
      mock = {}
      expect(Puppet::Util::IniConfig::File).to receive(:new).and_return(mock)
      expect(mock).to receive(:read).with('/etc/mistral/mistral.conf')
      expect do
        klass.mistral_credentials
      end.to raise_error(Puppet::Error, /Mistral types will not work/)
    end

    it 'should read conf file with all sections' do
      creds_hash = {
        'auth_url'            => 'https://192.168.56.210:5000/v3/',
        'project_name'        => 'admin_tenant',
        'username'            => 'admin',
        'password'            => 'password',
        'project_domain_name' => 'Default',
        'user_domain_name'    => 'Default',
      }
      mock = {
        'keystone_authtoken' => {
          'auth_url'     => 'https://192.168.56.210:5000/v3/',
          'project_name' => 'admin_tenant',
          'username'     => 'admin',
          'password'     => 'password',
        }
      }
      expect(Puppet::Util::IniConfig::File).to receive(:new).and_return(mock)
      expect(mock).to receive(:read).with('/etc/mistral/mistral.conf')
      expect(klass.mistral_credentials).to eq(creds_hash)
    end

  end
end
