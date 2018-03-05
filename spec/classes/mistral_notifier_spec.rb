require 'spec_helper'

describe 'mistral::notifier' do

  shared_examples_for 'mistral notifier' do
    it 'configure notifier default params' do
      is_expected.to contain_mistral_config('notifier/type').with_value('<SERVICE DEFAULT>')
      is_expected.to contain_mistral_config('notifier/host').with_value('<SERVICE DEFAULT>')
      is_expected.to contain_mistral_config('notifier/topic').with_value('<SERVICE DEFAULT>')
      is_expected.to contain_mistral_config('notifier/notify').with_value('<SERVICE DEFAULT>')
    end

    context 'with specific parameters' do
      let :params do
        { :type => "remote",
          :host => "localhost",
          :topic => "mistral-event-stream",
          :notify_publishers => "[{'type': 'noop'}]",
        }
      end

      it 'configure notifier params' do
        is_expected.to contain_mistral_config('notifier/type').with_value('remote')
        is_expected.to contain_mistral_config('notifier/host').with_value('localhost')
        is_expected.to contain_mistral_config('notifier/topic').with_value('mistral-event-stream')
        is_expected.to contain_mistral_config('notifier/notify').with_value("[{'type': 'noop'}]")
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

      it_configures 'mistral notifier'
    end
  end

end
