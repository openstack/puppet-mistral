require 'spec_helper'

describe 'mistral::db::sync' do

  shared_examples_for 'mistral-db-sync' do

    it 'runs mistral-db-manage upgrade head' do

      is_expected.to contain_exec('mistral-db-sync').with(
        :command     => 'mistral-db-manage --config-file=/etc/mistral/mistral.conf upgrade head',
        :path        => '/usr/bin',
        :user        => 'mistral',
        :refreshonly => 'true',
        :try_sleep   => 5,
        :tries       => 10,
        :logoutput   => 'on_failure'
      )

      is_expected.to contain_exec('mistral-db-populate').with(
        :command     => 'mistral-db-manage --config-file=/etc/mistral/mistral.conf populate',
        :path        => '/usr/bin',
        :user        => 'mistral',
        :refreshonly => 'true',
        :logoutput   => 'on_failure'
      )

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

      it_configures 'mistral-db-sync'
    end
  end

end
