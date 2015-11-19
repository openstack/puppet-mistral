require 'spec_helper'

describe 'mistral' do

  let :params do
    {
      :auth_uri          => 'http://127.0.0.1:5000/',
      :identity_uri      => 'http://127.0.0.1:35357/',
    }
  end

  shared_examples_for 'mistral' do

    it { is_expected.to contain_class('mistral::params') }

    it 'configures auth_uri' do
      is_expected.to contain_mistral_config('keystone_authtoken/auth_uri').with_value( params[:auth_uri] )
    end

    it 'configures identity_uri' do
      is_expected.to contain_mistral_config('keystone_authtoken/identity_uri').with_value( params[:identity_uri] )
    end

    it 'installs mistral package' do
      is_expected.to contain_package('mistral-common').with(
        :ensure => 'present',
        :name   => platform_params[:common_package_name],
        :tag    => ['openstack', 'mistral-package'],
      )
    end

  end

  context 'on Debian platforms' do
    let :facts do
      { :osfamily => 'Debian' }
    end

    let :platform_params do
      { :common_package_name => 'mistral' }
    end

    it_configures 'mistral'
  end

  context 'on RedHat platforms' do
    let :facts do
      { :osfamily => 'RedHat' }
    end

    let :platform_params do
      { :common_package_name => 'openstack-mistral-common' }
    end

    it_configures 'mistral'
  end

end
