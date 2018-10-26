require 'spec_helper'

describe 'mistral::api' do

  let :params do
    { :api_workers                     => '1',
      :enabled                         => true,
      :manage_service                  => true,
      :bind_host                       => '127.0.0.1',
      :bind_port                       => '1234',
      :enable_proxy_headers_parsing    => false,
      :allow_action_execution_deletion => false}
  end

  let :pre_condition do
    "class { '::mistral::keystone::authtoken':
      password => 'foo',
    }"
  end

  shared_examples_for 'mistral-api' do

    context 'config params' do

      it { is_expected.to contain_class('mistral::params') }
      it { is_expected.to contain_class('mistral::policy') }
      it { is_expected.to contain_class('mistral::keystone::authtoken') }

      it { is_expected.to contain_mistral_config('api/api_workers').with_value( params[:api_workers] ) }
      it { is_expected.to contain_mistral_config('api/host').with_value( params[:bind_host] ) }
      it { is_expected.to contain_mistral_config('api/port').with_value( params[:bind_port] ) }
      it { is_expected.to contain_oslo__middleware('mistral_config').with(
        :enable_proxy_headers_parsing => params[:enable_proxy_headers_parsing],
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
            :ensure     => (params[:manage_service] && params[:enabled]) ? 'running' : 'stopped',
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

    context 'with disabled service managing' do
      before do
        params.merge!({
          :manage_service => false,
          :enabled        => false })
      end

      it 'configures mistral-api service' do

        is_expected.to contain_service('mistral-api').with(
          :ensure     => nil,
          :name       => platform_params[:api_service_name],
          :enable     => false,
          :hasstatus  => true,
          :hasrestart => true,
          :tag        => 'mistral-service',
        )
        is_expected.to contain_service('mistral-api').that_subscribes_to(nil)
      end
    end

    context 'when running mistral-api in wsgi' do
      before do
        params.merge!({ :service_name   => 'httpd' })
      end

      let :pre_condition do
        "include ::apache
         include ::mistral::db
         class { '::mistral': }
         class { '::mistral::keystone::authtoken':
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

      it_raises 'a Puppet::Error', /Invalid service_name/
    end
  end

  context 'on Debian platforms' do
    let :facts do
      @default_facts.merge({
        :osfamily               => 'Debian',
        :operatingsystem        => 'Debian',
        :operatingsystemrelease => '8.0',
        :concat_basedir         => '/var/lib/puppet/concat',
        :fqdn                   => 'some.host.tld',
        :os                     => { :name  => 'Debian', :family => 'Debian', :release => { :major => '8', :minor => '0' } },
      })
    end

    let :platform_params do
      { :api_service_name => 'mistral-api' }
    end

    it_configures 'mistral-api'
  end

  context 'on RedHat platforms' do
    let :facts do
      @default_facts.merge({
        :osfamily               => 'RedHat',
        :operatingsystem        => 'RedHat',
        :operatingsystemrelease => '7.1',
        :fqdn                   => 'some.host.tld',
        :concat_basedir         => '/var/lib/puppet/concat',
        :os                     => { :name  => 'RedHat', :family => 'RedHat', :release => { :major => '7', :minor => '1' } },
      })
    end

    let :platform_params do
      { :api_service_name => 'openstack-mistral-api' }
    end

    it_configures 'mistral-api'
  end

end
