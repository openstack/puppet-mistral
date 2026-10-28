require 'spec_helper'

describe 'mistral::extra' do

  shared_examples_for 'mistral::extra' do
    context 'with defaults' do
      it 'installs mistral-extra package' do
        is_expected.to contain_package('mistral-extra').with(
          :ensure => 'present',
          :name   => platform_params[:extra_package_name],
          :tag    => ['openstack', 'mistral-package']
        )
      end
    end

    context 'with parameters' do
      let :params do
        { :package_ensure => 'latest' }
      end
      it 'installs mistral-extra package' do
        is_expected.to contain_package('mistral-extra').with(
          :ensure => 'latest',
          :name   => platform_params[:extra_package_name],
          :tag    => ['openstack', 'mistral-package']
        )
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
            :extra_package_name => 'mistral-extra',
          }
        when 'RedHat'
          {
            :extra_package_name => 'python3-mistral-extra',
          }
        end
      end

      it_configures 'mistral::extra'
    end
  end

end
