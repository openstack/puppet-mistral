require 'spec_helper'

describe 'mistral::engine' do
  let :params do
    {}
  end

  shared_examples 'mistral::engine' do
    context 'with defaults' do
      it { is_expected.to contain_class('mistral::params') }

      it 'configures mistral-engine parameters' do
        is_expected.to contain_mistral_config('engine/host')\
          .with_value('<SERVICE DEFAULT>')
        is_expected.to contain_mistral_config('engine/topic')\
          .with_value('<SERVICE DEFAULT>')
        is_expected.to contain_mistral_config('engine/version')\
          .with_value('<SERVICE DEFAULT>')
        is_expected.to contain_mistral_config('engine/execution_field_size_limit_kb')
          .with_value('<SERVICE DEFAULT>')
        is_expected.to contain_mistral_config('engine/execution_integrity_check_delay')
          .with_value('<SERVICE DEFAULT>')
        is_expected.to contain_mistral_config('engine/execution_integrity_check_batch_size')
          .with_value('<SERVICE DEFAULT>')
        is_expected.to contain_mistral_config('engine/action_definition_cache_time')
          .with_value('<SERVICE DEFAULT>')
        is_expected.to contain_mistral_config('engine/start_subworkflows_via_rpc')
          .with_value('<SERVICE DEFAULT>')

        is_expected.to contain_mistral_config('execution_expiration_policy/evaluation_interval')\
          .with_value('<SERVICE DEFAULT>')
        is_expected.to contain_mistral_config('execution_expiration_policy/older_than')\
          .with_value('<SERVICE DEFAULT>')
      end
    end

    context 'config params' do
      before do
        params.merge!({
          :host                                 => 'foo_host',
          :topic                                => 'foo_topic',
          :version                              => '1.0',
          :execution_field_size_limit_kb        => 1024,
          :execution_integrity_check_delay      => 20,
          :execution_integrity_check_batch_size => 5,
          :action_definition_cache_time         => 60,
          :start_subworkflows_via_rpc           => false,
          :evaluation_interval                  => 1234,
          :older_than                           => 60
        })
      end

      it 'configures mistral-engine parameters' do
        is_expected.to contain_mistral_config('engine/host')\
          .with_value(params[:host])
        is_expected.to contain_mistral_config('engine/topic')\
          .with_value(params[:topic])
        is_expected.to contain_mistral_config('engine/version')\
          .with_value(params[:version])
        is_expected.to contain_mistral_config('engine/execution_field_size_limit_kb')
          .with_value(params[:execution_field_size_limit_kb])
        is_expected.to contain_mistral_config('engine/execution_integrity_check_delay')
          .with_value(params[:execution_integrity_check_delay])
        is_expected.to contain_mistral_config('engine/execution_integrity_check_batch_size')
          .with_value(params[:execution_integrity_check_batch_size])
        is_expected.to contain_mistral_config('engine/action_definition_cache_time')
          .with_value(params[:action_definition_cache_time])
        is_expected.to contain_mistral_config('engine/start_subworkflows_via_rpc')
          .with_value(params[:start_subworkflows_via_rpc])

        is_expected.to contain_mistral_config('execution_expiration_policy/evaluation_interval')\
          .with_value(params[:evaluation_interval])
        is_expected.to contain_mistral_config('execution_expiration_policy/older_than')\
          .with_value(params[:older_than])
      end
    end

    [{:enabled => true}, {:enabled => false}].each do |param_hash|
      context "when service should be #{param_hash[:enabled] ? 'enabled' : 'disabled'}" do
        before do
          params.merge!(param_hash)
        end

        it 'configures mistral-engine service' do
          is_expected.to contain_service('mistral-engine').with(
            :ensure     => params[:enabled] ? 'running' : 'stopped',
            :name       => platform_params[:engine_service_name],
            :enable     => params[:enabled],
            :hasstatus  => true,
            :hasrestart => true,
            :tag        => 'mistral-service',
         )
          is_expected.to contain_service('mistral-engine').that_subscribes_to(nil)
        end
      end
    end

    context 'with disabled service managing' do
      before do
        params.merge!({
          :manage_service => false
        })
      end

      it 'does not configure mistral-engine service' do
        is_expected.to_not contain_service('mistral-engine')
      end
    end
  end

  on_supported_os({
    :supported_os => OSDefaults.get_supported_os
  }).each do |os,facts|
    context "on #{os}" do
      let (:facts) do
        facts.merge!(OSDefaults.get_facts())
      end

      let (:platform_params) do
        case facts[:osfamily]
        when 'Debian'
          { :engine_service_name => 'mistral-engine' }
        when 'RedHat'
          { :engine_service_name => 'openstack-mistral-engine' }
        end
      end

      it_behaves_like 'mistral::engine'
    end
  end
end
