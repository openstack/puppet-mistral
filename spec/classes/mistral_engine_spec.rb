require 'spec_helper'

describe 'mistral::engine' do

  let :params do
    { :enabled                            => true,
      :manage_service                     => true,
      :host                               => 'foo_host',
      :topic                              => 'foo_topic',
      :version                            => '1.0',
      :execution_field_size_limit_kb      => '1234',
      :evaluation_interval                => 1234,
      :older_than                         => 60}
  end

  shared_examples_for 'mistral-engine' do

    context 'config params' do

      it { is_expected.to contain_class('mistral::params') }

      it { is_expected.to contain_mistral_config('engine/host').with_value( params[:host] ) }
      it { is_expected.to contain_mistral_config('engine/topic').with_value( params[:topic] ) }
      it { is_expected.to contain_mistral_config('engine/version').with_value( params[:version] ) }
      it { is_expected.to contain_mistral_config('engine/execution_field_size_limit_kb').with_value( params[:execution_field_size_limit_kb] ) }
      it { is_expected.to contain_mistral_config('execution_expiration_policy/evaluation_interval').with_value( params[:evaluation_interval] ) }
      it { is_expected.to contain_mistral_config('execution_expiration_policy/older_than').with_value( params[:older_than] ) }

    end

    [{:enabled => true}, {:enabled => false}].each do |param_hash|
      context "when service should be #{param_hash[:enabled] ? 'enabled' : 'disabled'}" do
        before do
          params.merge!(param_hash)
        end

        it 'configures mistral-engine service' do

          is_expected.to contain_service('mistral-engine').with(
            :ensure     => (params[:manage_service] && params[:enabled]) ? 'running' : 'stopped',
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
          :manage_service => false,
          :enabled        => false })
      end

      it 'configures mistral-engine service' do

        is_expected.to contain_service('mistral-engine').with(
          :ensure     => nil,
          :name       => platform_params[:engine_service_name],
          :enable     => false,
          :hasstatus  => true,
          :hasrestart => true,
          :tag        => 'mistral-service',
        )
        is_expected.to contain_service('mistral-engine').that_subscribes_to(nil)
      end
    end

  end

  context 'on Debian platforms' do
    let :facts do
      OSDefaults.get_facts({
        :osfamily => 'Debian',
        :os       => { :name  => 'Debian', :family => 'Debian', :release => { :major => '8', :minor => '0' } },
      })
    end

    let :platform_params do
      { :engine_service_name => 'mistral-engine' }
    end

    it_configures 'mistral-engine'
  end

  context 'on RedHat platforms' do
    let :facts do
      OSDefaults.get_facts({
        :osfamily => 'RedHat',
        :os       => { :name  => 'CentOS', :family => 'RedHat', :release => { :major => '7', :minor => '0' } },
      })
    end

    let :platform_params do
      { :engine_service_name => 'openstack-mistral-engine' }
    end

    it_configures 'mistral-engine'
  end

end
