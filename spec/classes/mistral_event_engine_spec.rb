require 'spec_helper'

describe 'mistral::event_engine' do

  let :params do
    { :enabled                            => true,
      :manage_service                     => true,
      :host                               => 'foo_host',
      :topic                              => 'foo_topic',
      :event_definitions_cfg_file         => 'foo_cfg_file'}
  end

  shared_examples_for 'mistral-event-engine' do

    context 'config params' do

      it { is_expected.to contain_class('mistral::params') }

      it { is_expected.to contain_mistral_config('event_engine/host').with_value( params[:host] ) }
      it { is_expected.to contain_mistral_config('event_engine/topic').with_value( params[:topic] ) }
      it { is_expected.to contain_mistral_config('event_engine/event_definitions_cfg_file').with_value( params[:event_definitions_cfg_file] ) }

    end

    [{:enabled => true}, {:enabled => false}].each do |param_hash|
      context "when service should be #{param_hash[:enabled] ? 'enabled' : 'disabled'}" do
        before do
          params.merge!(param_hash)
        end

        it 'configures mistral-event-engine service' do

          is_expected.to contain_service('mistral-event-engine').with(
            :ensure     => params[:enabled] ? 'running' : 'stopped',
            :name       => platform_params[:event_engine_service_name],
            :enable     => params[:enabled],
            :hasstatus  => true,
            :hasrestart => true,
            :tag        => 'mistral-service',
          )
          is_expected.to contain_service('mistral-event-engine').that_subscribes_to(nil)
        end
      end
    end

    context 'with disabled service managing' do
      before do
        params.merge!({
          :manage_service => false
        })
      end

      it 'does not configure mistral-event-engine service' do
        is_expected.to_not contain_service('mistral-event-engine')
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

      let(:platform_params) do
        case facts[:os]['family']
        when 'Debian'
          { :event_engine_service_name => 'mistral-event-engine' }
        when 'RedHat'
          { :event_engine_service_name => 'openstack-mistral-event-engine' }
        end
      end

      it_configures 'mistral-event-engine'
    end
  end

end
