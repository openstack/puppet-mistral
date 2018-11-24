require 'spec_helper'

describe 'mistral::config' do
  shared_examples 'mistral::config' do
    let :params do
      {
        :mistral_config => {
          'DEFAULT/foo' => { 'value'  => 'fooValue' },
          'DEFAULT/bar' => { 'value'  => 'barValue' },
          'DEFAULT/baz' => { 'ensure' => 'absent' }
        }
      }
    end

    it { should contain_class('mistral::deps') }

    it {
      should contain_mistral_config('DEFAULT/foo').with_value('fooValue')
      should contain_mistral_config('DEFAULT/bar').with_value('barValue')
      should contain_mistral_config('DEFAULT/baz').with_ensure('absent')
    }
  end

  on_supported_os({
    :supported_os => OSDefaults.get_supported_os
  }).each do |os,facts|
    context "on #{os}" do
      let (:facts) do
        facts.merge!(OSDefaults.get_facts())
      end

      it_behaves_like 'mistral::config'
    end
  end
end
