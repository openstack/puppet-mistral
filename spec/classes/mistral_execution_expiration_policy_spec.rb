require 'spec_helper'

describe 'mistral::execution_expiration_policy' do

  shared_examples_for 'mistral::execution_expiration_policy' do
    context 'with defaults' do
      it 'configures execution_expiration_policy parameters' do
        is_expected.to contain_mistral_config('execution_expiration_policy/evaluation_interval')\
          .with_value('<SERVICE DEFAULT>')
        is_expected.to contain_mistral_config('execution_expiration_policy/older_than')\
          .with_value('<SERVICE DEFAULT>')
        is_expected.to contain_mistral_config('execution_expiration_policy/max_finished_executions')\
          .with_value('<SERVICE DEFAULT>')
        is_expected.to contain_mistral_config('execution_expiration_policy/batch_size')\
          .with_value('<SERVICE DEFAULT>')
        is_expected.to contain_mistral_config('execution_expiration_policy/ignored_states')\
          .with_value('<SERVICE DEFAULT>')
      end
    end

    context 'with specific parameters' do
      let :params do
        {
          :evaluation_interval     => 120,
          :older_than              => 1,
          :max_finished_executions => 0,
          :batch_size              => 10,
          :ignored_states          => ['SUCCESS', 'ERROR', 'CANCELLED']
        }
      end

      it 'configures execution_expiration_policy parameters' do
        is_expected.to contain_mistral_config('execution_expiration_policy/evaluation_interval')\
          .with_value(120)
        is_expected.to contain_mistral_config('execution_expiration_policy/older_than')\
          .with_value(1)
        is_expected.to contain_mistral_config('execution_expiration_policy/max_finished_executions')\
          .with_value(0)
        is_expected.to contain_mistral_config('execution_expiration_policy/batch_size')\
          .with_value(10)
        is_expected.to contain_mistral_config('execution_expiration_policy/ignored_states')\
          .with_value('SUCCESS,ERROR,CANCELLED')
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

      it_configures 'mistral::execution_expiration_policy'
    end
  end
end
