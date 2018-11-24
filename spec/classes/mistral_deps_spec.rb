require 'spec_helper'

describe 'mistral::deps' do
  shared_examples 'mistral::deps' do
    it {
      should contain_anchor('mistral::install::begin')
      should contain_anchor('mistral::install::end')
      should contain_anchor('mistral::config::begin')
      should contain_anchor('mistral::config::end')
      should contain_anchor('mistral::db::begin')
      should contain_anchor('mistral::db::end')
      should contain_anchor('mistral::dbsync::begin')
      should contain_anchor('mistral::dbsync::end')
      should contain_anchor('mistral::service::begin')
      should contain_anchor('mistral::service::end')
    }
  end

  on_supported_os({
    :supported_os => OSDefaults.get_supported_os
  }).each do |os,facts|
    context "on #{os}" do
      let (:facts) do
        facts.merge!(OSDefaults.get_facts())
      end

      it_behaves_like 'mistral::deps'
    end
  end
end
