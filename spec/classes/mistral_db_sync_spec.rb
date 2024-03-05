require 'spec_helper'

describe 'mistral::db::sync' do

  shared_examples_for 'mistral-db-sync' do

    it { is_expected.to contain_class('mistral::deps') }

    it 'runs mistral-db-manage upgrade head' do

      is_expected.to contain_exec('mistral-db-sync').with(
        :command     => 'mistral-db-manage upgrade head',
        :path        => '/usr/bin',
        :user        => 'mistral',
        :refreshonly => 'true',
        :try_sleep   => 5,
        :tries       => 10,
        :timeout     => 300,
        :logoutput   => 'on_failure',
        :subscribe   => ['Anchor[mistral::install::end]',
                         'Anchor[mistral::config::end]',
                         'Anchor[mistral::dbsync::begin]'],
        :notify      => 'Anchor[mistral::dbsync::end]',
        :tag         => 'openstack-db',
      )

      is_expected.to contain_exec('mistral-db-populate').with(
        :command     => 'mistral-db-manage populate',
        :path        => '/usr/bin',
        :user        => 'mistral',
        :refreshonly => 'true',
        :timeout     => 300,
        :logoutput   => 'on_failure',
        :subscribe   => ['Anchor[mistral::install::end]',
                         'Anchor[mistral::config::end]',
                         'Anchor[mistral::dbsync::begin]'],
        :notify      => 'Anchor[mistral::dbsync::end]',
        :tag         => 'openstack-db',
      )

    end

  end

  on_supported_os({
    :supported_os   => OSDefaults.get_supported_os
  }).each do |os,facts|
    context "on #{os}" do
      let (:facts) do
        facts.merge(OSDefaults.get_facts())
      end

      it_configures 'mistral-db-sync'
    end
  end

end
