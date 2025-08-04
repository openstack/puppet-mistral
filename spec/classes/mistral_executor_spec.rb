require 'spec_helper'

describe 'mistral::executor' do

  shared_examples_for 'mistral::executor' do
    context 'with defaults' do
      it 'configure executor default params' do
        is_expected.to contain_mistral_config('executor/type').with_value('remote')
        is_expected.to contain_mistral_config('executor/host').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_mistral_config('executor/topic').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_mistral_config('executor/version').with_value('<SERVICE DEFAULT>')
      end

      it 'installs mistral-executor package' do
        is_expected.to contain_package('mistral-executor').with(
          :ensure => 'present',
          :name   => platform_params[:executor_package_name],
          :tag    => ['openstack', 'mistral-package']
        )
      end

      it 'configures mistral-executor service' do
        is_expected.to contain_service('mistral-executor').with(
          :ensure     => 'running',
          :name       => platform_params[:executor_service_name],
          :enable     => true,
          :hasstatus  => true,
          :hasrestart => true,
          :tag        => 'mistral-service',
        )
      end
    end

    context 'with specific parameters' do
      let :params do
        { :type    => 'local',
          :host    => 'localhost',
          :topic   => 'mistral_executor',
          :version => '1.0'
        }
      end

      it 'configure executor params' do
        is_expected.to contain_mistral_config('executor/type').with_value('local')
        is_expected.to contain_mistral_config('executor/host').with_value('localhost')
        is_expected.to contain_mistral_config('executor/topic').with_value('mistral_executor')
        is_expected.to contain_mistral_config('executor/version').with_value('1.0')
      end

      it 'disables mistral-executor service' do
        is_expected.to contain_service('mistral-executor').with(
          :ensure     => 'stopped',
          :name       => platform_params[:executor_service_name],
          :enable     => false,
          :hasstatus  => true,
          :hasrestart => true,
          :tag        => 'mistral-service',
        )
      end
    end

    context 'with service disabled' do
      let :params do
        { :enabled => false }
      end

      it 'configures mistral-executor service' do
        is_expected.to contain_service('mistral-executor').with(
          :ensure     => 'stopped',
          :name       => platform_params[:executor_service_name],
          :enable     => false,
          :hasstatus  => true,
          :hasrestart => true,
          :tag        => 'mistral-service',
        )
      end
    end

    context 'with service unmanaged' do
      let :params do
        { :manage_service => false }
      end

      it 'does not configure mistral-executor service' do
        is_expected.to_not contain_service('mistral-executor')
      end
    end
  end

  on_supported_os({
    :supported_os   => OSDefaults.get_supported_os
  }).each do |os,facts|
    context "on #{os}" do
      let (:facts) do
        facts.merge!(OSDefaults.get_facts())
      end

      let (:platform_params) do
        case facts[:os]['family']
        when 'Debian'
          {
            :executor_package_name => 'mistral-executor',
            :executor_service_name => 'mistral-executor'
          }
        when 'RedHat'
          {
            :executor_package_name => 'openstack-mistral-executor',
            :executor_service_name => 'openstack-mistral-executor'
          }
        end
      end

      it_configures 'mistral::executor'
    end
  end

end
