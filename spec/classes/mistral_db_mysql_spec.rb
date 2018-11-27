require 'spec_helper'

describe 'mistral::db::mysql' do
  let :pre_condition do
    "include mysql::server"
  end

  let :params do
    {
      :password => 'fooboozoo_default_password',
    }
  end

  shared_examples 'mistral::db::mysql' do
    context 'with only required params' do
      it { should contain_openstacklib__db__mysql('mistral').with(
        :user          => 'mistral',
        :password_hash => '*3DDF34A86854A312A8E2C65B506E21C91800D206',
        :dbname        => 'mistral',
        :host          => '127.0.0.1',
        :charset       => 'utf8',
        :collate       => 'utf8_general_ci',
      )}
    end

    context 'overriding allowed_hosts param to array' do
      before do
        params.merge!( :allowed_hosts => ['127.0.01', '%'] )
      end

      it { should contain_openstacklib__db__mysql('mistral').with(
        :allowed_hosts => params[:allowed_hosts],
      )}
    end

    context 'overriding allowed_hosts param to string' do
      before do
        params.merge!( :allowed_hosts => '192.168.1.1' )
      end

      it { should contain_openstacklib__db__mysql('mistral').with(
        :allowed_hosts => params[:allowed_hosts],
      )}
    end
  end

  on_supported_os({
    :supported_os => OSDefaults.get_supported_os
  }).each do |os,facts|
    context "on #{os}" do
      let (:facts) do
        facts.merge!(OSDefaults.get_facts())
      end

      it_behaves_like 'mistral::db::mysql'
    end
  end
end
