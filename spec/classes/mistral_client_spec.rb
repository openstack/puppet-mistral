require 'spec_helper'

describe 'mistral::client' do

  shared_examples_for 'mistral client' do

    it { is_expected.to contain_class('mistral::deps') }
    it { is_expected.to contain_class('mistral::params') }

    it 'installs mistral client package' do
      is_expected.to contain_package('python-mistralclient').with(
        :ensure => 'present',
        :name   => platform_params[:client_package],
        :tag    => ['openstack', 'openstackclient']
      )
    end

    it { is_expected.to contain_class('openstacklib::openstackclient') }
  end

  on_supported_os({
    :supported_os => OSDefaults.get_supported_os
  }).each do |os,facts|
    context "on #{os}" do
      let (:facts) do
        facts.merge!(OSDefaults.get_facts())
      end

      let(:platform_params) do
        case facts[:os]['family']
        when 'Debian'
          { :client_package => 'python3-mistralclient' }
        when 'RedHat'
          { :client_package => 'python3-mistralclient' }
        end
      end

      it_behaves_like 'mistral client'
    end
  end

end
