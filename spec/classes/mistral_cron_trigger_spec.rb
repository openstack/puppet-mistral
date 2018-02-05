require 'spec_helper'

describe 'mistral::cron_trigger' do

  shared_examples_for 'mistral cron trigger' do
    it 'configure cron trigger default params' do
      is_expected.to contain_mistral_config('cron_trigger/enabled').with_value('<SERVICE DEFAULT>')
      is_expected.to contain_mistral_config('cron_trigger/execution_interval').with_value('<SERVICE DEFAULT>')
    end

    context 'with specific parameters' do
      let :params do
        { :enabled => true,
          :execution_interval => 60,
        }
      end

      it 'configure cron trigger params' do
        is_expected.to contain_mistral_config('cron_trigger/enabled').with_value(true)
        is_expected.to contain_mistral_config('cron_trigger/execution_interval').with_value(60)
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

      it_configures 'mistral cron trigger'
    end
  end

end
