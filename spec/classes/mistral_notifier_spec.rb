require 'spec_helper'

describe 'mistral::notifier' do

  shared_examples_for 'mistral::notifier' do
    context 'with defaults' do
      it 'configure notifier default params' do
        is_expected.to contain_mistral_config('notifier/type').with_value('remote')
        is_expected.to contain_mistral_config('notifier/host').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_mistral_config('notifier/topic').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_mistral_config('notifier/notify').with_value('<SERVICE DEFAULT>')
      end

      it 'installs mistral-notifier package' do
        if platform_params.has_key?(:notifier_package_name)
          is_expected.to contain_package('mistral-notifier').with(
            :ensure => 'present',
            :name   => platform_params[:notifier_package_name],
            :tag    => ['openstack', 'mistral-package']
          )
        end
      end

      it 'configures mistral-notifier service' do
        if platform_params.has_key?(:notifier_service_name)
          is_expected.to contain_service('mistral-notifier').with(
            :ensure     => 'running',
            :name       => platform_params[:notifier_service_name],
            :enable     => true,
            :hasstatus  => true,
            :hasrestart => true,
            :tag        => 'mistral-service',
          )
        end
      end
    end

    context 'with specific parameters' do
      let :params do
        { :type              => 'local',
          :host              => 'localhost',
          :topic             => 'mistral-event-stream',
          :notify_publishers => '[{\'type\': \'noop\'}]',
        }
      end

      it 'configure notifier params' do
        is_expected.to contain_mistral_config('notifier/type').with_value('local')
        is_expected.to contain_mistral_config('notifier/host').with_value('localhost')
        is_expected.to contain_mistral_config('notifier/topic').with_value('mistral-event-stream')
        is_expected.to contain_mistral_config('notifier/notify').with_value("[{'type': 'noop'}]")
      end

      it 'disables mistral-notifier service' do
        if platform_params.has_key?(:notifier_service_name)
          is_expected.to contain_service('mistral-notifier').with(
            :ensure     => 'stopped',
            :name       => platform_params[:notifier_service_name],
            :enable     => false,
            :hasstatus  => true,
            :hasrestart => true,
            :tag        => 'mistral-service',
          )
        end
      end
    end

    context 'with service disabled' do
      let :params do
        { :enabled => false }
      end

      it 'configures mistral-notifier service' do
        if platform_params.has_key?(:notifier_service_name)
          is_expected.to contain_service('mistral-notifier').with(
            :ensure     => 'stopped',
            :name       => platform_params[:notifier_service_name],
            :enable     => false,
            :hasstatus  => true,
            :hasrestart => true,
            :tag        => 'mistral-service',
          )
        end
      end
    end

    context 'with service unmanaged' do
      let :params do
        { :manage_service => false }
      end

      it 'does not configure mistral-notifier service' do
        is_expected.to_not contain_service('mistral-notifier')
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
          {}
        when 'RedHat'
          {
            :notifier_package_name => 'openstack-mistral-notifier',
            :notifier_service_name => 'openstack-mistral-notifier'
          }
        end
      end

      it_configures 'mistral::notifier'
    end
  end

end
