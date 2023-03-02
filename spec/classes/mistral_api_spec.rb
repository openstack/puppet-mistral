require 'spec_helper'

describe 'mistral::api' do
  let :params do
    {
      :api_workers                     => '1',
      :enabled                         => true,
      :manage_service                  => true,
      :bind_host                       => '127.0.0.1',
      :bind_port                       => '1234',
      :enable_proxy_headers_parsing    => false,
      :max_request_body_size           => '102400',
      :allow_action_execution_deletion => false
    }
  end

  let :pre_condition do
    "class { 'mistral::keystone::authtoken':
       password => 'foo',
    }"
  end

  shared_examples 'mistral::api' do
    context 'config params' do
      it { is_expected.to contain_class('mistral::params') }
      it { is_expected.to contain_class('mistral::policy') }
      it { is_expected.to contain_class('mistral::keystone::authtoken') }

      it { is_expected.to contain_mistral_config('api/api_workers').with_value( params[:api_workers] ) }
      it { is_expected.to contain_mistral_config('api/host').with_value( params[:bind_host] ) }
      it { is_expected.to contain_mistral_config('api/port').with_value( params[:bind_port] ) }
      it { is_expected.to contain_oslo__middleware('mistral_config').with(
        :enable_proxy_headers_parsing => params[:enable_proxy_headers_parsing],
        :max_request_body_size        => params[:max_request_body_size],
      )}
      it { is_expected.to contain_mistral_config('api/allow_action_execution_deletion').with_value( params[:allow_action_execution_deletion] ) }

    end

    [{:enabled => true}, {:enabled => false}].each do |param_hash|
      context "when service should be #{param_hash[:enabled] ? 'enabled' : 'disabled'}" do
        before do
          params.merge!(param_hash)
        end

        it 'configures mistral-api service' do
          is_expected.to contain_service('mistral-api').with(
            :ensure     => params[:enabled] ? 'running' : 'stopped',
            :name       => platform_params[:api_service_name],
            :enable     => params[:enabled],
            :hasstatus  => true,
            :hasrestart => true,
            :tag        => 'mistral-service',
          )
          is_expected.to contain_service('mistral-api').that_subscribes_to(nil)
        end
      end
    end

    context 'with enable_proxy_headers_parsing' do
      before do
        params.merge!({:enable_proxy_headers_parsing => true })
      end

      it { is_expected.to contain_oslo__middleware('mistral_config').with(
        :enable_proxy_headers_parsing => params[:enable_proxy_headers_parsing],
      )}
    end

    context 'with max_request_body_size' do
      before do
        params.merge!({:max_request_body_size => '102400' })
      end

      it { is_expected.to contain_oslo__middleware('mistral_config').with(
        :max_request_body_size => params[:max_request_body_size],
      )}
    end

    context 'with disabled service managing' do
      before do
        params.merge!({
          :manage_service => false
        })
      end

      it 'does not configure mistral-api service' do
        is_expected.to_not contain_service('mistral-api')
      end
    end

    context 'when running mistral-api in wsgi' do
      before do
        params.merge!({ :service_name   => 'httpd' })
      end

      let :pre_condition do
        "include apache
         include mistral::db
         class { 'mistral': }
         class { 'mistral::keystone::authtoken':
             password => 'foo',
         }"
      end

      it 'configures mistral-api service with Apache' do
        is_expected.to contain_service('mistral-api').with(
          :ensure     => 'stopped',
          :name       => platform_params[:api_service_name],
          :enable     => false,
          :tag        => ['mistral-service'],
        )
      end
    end

    context 'when service_name is not valid' do
      before do
        params.merge!({ :service_name => 'foobar' })
      end

      it { should raise_error(Puppet::Error, /Invalid service_name/) }
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
        case facts[:os]['family']
        when 'Debian'
          { :api_service_name => 'mistral-api' }
        when 'RedHat'
          { :api_service_name => 'openstack-mistral-api' }
        end
      end

      it_behaves_like 'mistral::api'
    end
  end
end
