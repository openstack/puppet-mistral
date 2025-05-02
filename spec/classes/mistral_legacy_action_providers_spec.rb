require 'spec_helper'

describe 'mistral::legacy_action_providers' do
  let :params do
    {}
  end

  shared_examples 'mistral::legacy_action_providers' do
    context 'with defaults' do
      it {
        is_expected.to contain_mistral_config('legacy_action_providers/load_action_plugins').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_mistral_config('legacy_action_providers/load_action_generators').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_mistral_config('legacy_action_providers/only_builtin_actions').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_mistral_config('legacy_action_providers/allowlist').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_mistral_config('legacy_action_providers/denylist').with_value('<SERVICE DEFAULT>')
      }
    end

    context 'with parameters' do
      before do
        params.merge!({
          :load_action_plugins    => true,
          :load_action_generators => false,
          :only_builtin_actions   => true,
          :allowlist              => ['allow0', 'allow1'],
          :denylist               => ['deny0', 'deny1'],
        })
      end

      it {
        is_expected.to contain_mistral_config('legacy_action_providers/load_action_plugins').with_value(true)
        is_expected.to contain_mistral_config('legacy_action_providers/load_action_generators').with_value(false)
        is_expected.to contain_mistral_config('legacy_action_providers/only_builtin_actions').with_value(true)
        is_expected.to contain_mistral_config('legacy_action_providers/allowlist').with_value('allow0,allow1')
        is_expected.to contain_mistral_config('legacy_action_providers/denylist').with_value('deny0,deny1')
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

      it_behaves_like 'mistral::legacy_action_providers'
    end
  end
end
