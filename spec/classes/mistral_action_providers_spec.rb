require 'spec_helper'

describe 'mistral::action_providers' do
  let :params do
    {}
  end

  shared_examples 'mistral::action_providers' do
    context 'with defaults' do
      it {
        is_expected.to contain_mistral_config('action_providers/allowlist').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_mistral_config('action_providers/denylist').with_value('<SERVICE DEFAULT>')
      }
    end

    context 'with parameters' do
      before do
        params.merge!({
          :allowlist => ['test'],
          :denylist  => ['test2'],
        })
      end

      it {
        is_expected.to contain_mistral_config('action_providers/allowlist').with_value(['test'])
        is_expected.to contain_mistral_config('action_providers/denylist').with_value(['test2'])
      }
    end
  end

  on_supported_os({
    :supported_os => OSDefaults.get_supported_os
  }).each do |os,facts|
    context "on #{os}" do
      let (:facts) do
        facts.merge!(OSDefaults.get_facts())
      end

      it_behaves_like 'mistral::action_providers'
    end
  end
end
