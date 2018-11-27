require 'spec_helper'

describe 'mistral::keystone::auth' do
  shared_examples 'mistral::keystone::auth' do
    context 'with default class parameters' do
      let :params do
        {
          :password => 'mistral_password',
          :tenant   => 'services'
        }
      end

      it { should contain_keystone_user('mistral').with(
        :ensure   => 'present',
        :password => 'mistral_password',
      )}

      it { should contain_keystone_user_role('mistral@services').with(
        :ensure  => 'present',
        :roles   => ['admin']
      )}

      it { should contain_keystone_service('mistral::workflowv2').with(
        :ensure      => 'present',
        :description => 'OpenStack Workflow Service'
      )}

      it { should contain_keystone_endpoint('RegionOne/mistral::workflowv2').with(
        :ensure       => 'present',
        :public_url   => "http://127.0.0.1:8989/v2",
        :admin_url    => "http://127.0.0.1:8989/v2",
        :internal_url => "http://127.0.0.1:8989/v2"
      )}
    end

    context 'when overriding auth and service name' do
      let :params do
        {
          :service_name => 'mistraly',
          :auth_name    => 'mistraly',
          :password     => 'mistral_password'
        }
      end

      it { should contain_keystone_user('mistraly') }
      it { should contain_keystone_user_role('mistraly@services') }
      it { should contain_keystone_service('mistraly::workflowv2') }
      it { should contain_keystone_endpoint('RegionOne/mistraly::workflowv2') }
    end

    context 'when disabling user configuration' do
      let :params do
        {
          :password       => 'mistral_password',
          :configure_user => false
        }
      end

      it { should_not contain_keystone_user('mistral') }
      it { should contain_keystone_user_role('mistral@services') }

      it { should contain_keystone_service('mistral::workflowv2').with(
        :ensure      => 'present',
        :description => 'OpenStack Workflow Service'
      )}
    end

    context 'when disabling user and user role configuration' do
      let :params do
        {
          :password            => 'mistral_password',
          :configure_user      => false,
          :configure_user_role => false
        }
      end

      it { should_not contain_keystone_user('mistral') }
      it { should_not contain_keystone_user_role('mistral@services') }

      it { should contain_keystone_service('mistral::workflowv2').with(
        :ensure      => 'present',
        :description => 'OpenStack Workflow Service'
      )}
    end
  end

  on_supported_os({
    :supported_os => OSDefaults.get_supported_os
  }).each do |os,facts|
    context "on #{os}" do
      let (:facts) do
        facts.merge!(OSDefaults.get_facts())
      end

      it_behaves_like 'mistral::keystone::auth'
    end
  end
end
