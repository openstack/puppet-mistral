require 'spec_helper'

describe 'mistral::db::postgresql' do

  shared_examples_for 'mistral::db::postgresql' do
    let :req_params do
      { :password => 'mistralpass' }
    end

    let :pre_condition do
      'include postgresql::server'
    end

    context 'with only required parameters' do
      let :params do
        req_params
      end

      it { is_expected.to contain_class('mistral::deps') }

      it { is_expected.to contain_openstacklib__db__postgresql('mistral').with(
        :user       => 'mistral',
        :password   => 'mistralpass',
        :dbname     => 'mistral',
        :encoding   => nil,
        :privileges => 'ALL',
      )}
    end

  end

  on_supported_os({
    :supported_os   => OSDefaults.get_supported_os
  }).each do |os,facts|
    context "on #{os}" do
      let (:facts) do
        facts.merge(OSDefaults.get_facts({
          :os_workers     => 8,
          :concat_basedir => '/var/lib/puppet/concat'
        }))
      end

      # TODO(tkajinam): Remove this once puppet-postgresql supports CentOS 9
      unless facts[:osfamily] == 'RedHat' and facts[:operatingsystemmajrelease].to_i >= 9
        it_configures 'mistral::db::postgresql'
      end
    end
  end

end
