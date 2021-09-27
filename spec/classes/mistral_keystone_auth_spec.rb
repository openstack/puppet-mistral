#
# Unit tests for mistral::keystone::auth
#

require 'spec_helper'

describe 'mistral::keystone::auth' do
  shared_examples_for 'mistral::keystone::auth' do
    context 'with default class parameters' do
      let :params do
        { :password => 'mistral_password' }
      end

      it { is_expected.to contain_keystone__resource__service_identity('mistral').with(
        :configure_user      => true,
        :configure_user_role => true,
        :configure_endpoint  => true,
        :service_name        => 'mistral',
        :service_type        => 'workflowv2',
        :service_description => 'OpenStack Workflow Service',
        :region              => 'RegionOne',
        :auth_name           => 'mistral',
        :password            => 'mistral_password',
        :email               => 'mistral@localhost',
        :tenant              => 'services',
        :public_url          => 'http://127.0.0.1:8989/v2',
        :internal_url        => 'http://127.0.0.1:8989/v2',
        :admin_url           => 'http://127.0.0.1:8989/v2',
      ) }
    end

    context 'when overriding parameters' do
      let :params do
        { :password            => 'mistral_password',
          :auth_name           => 'alt_mistral',
          :email               => 'alt_mistral@alt_localhost',
          :tenant              => 'alt_service',
          :configure_endpoint  => false,
          :configure_user      => false,
          :configure_user_role => false,
          :service_description => 'Alternative OpenStack Workflow Service',
          :service_name        => 'alt_service',
          :service_type        => 'alt_workflowv2',
          :region              => 'RegionTwo',
          :public_url          => 'https://10.10.10.10:80',
          :internal_url        => 'http://10.10.10.11:81',
          :admin_url           => 'http://10.10.10.12:81' }
      end

      it { is_expected.to contain_keystone__resource__service_identity('mistral').with(
        :configure_user      => false,
        :configure_user_role => false,
        :configure_endpoint  => false,
        :service_name        => 'alt_service',
        :service_type        => 'alt_workflowv2',
        :service_description => 'Alternative OpenStack Workflow Service',
        :region              => 'RegionTwo',
        :auth_name           => 'alt_mistral',
        :password            => 'mistral_password',
        :email               => 'alt_mistral@alt_localhost',
        :tenant              => 'alt_service',
        :public_url          => 'https://10.10.10.10:80',
        :internal_url        => 'http://10.10.10.11:81',
        :admin_url           => 'http://10.10.10.12:81',
      ) }
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
