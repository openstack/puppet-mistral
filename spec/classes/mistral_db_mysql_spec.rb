require 'spec_helper'

describe 'mistral::db::mysql' do
  let :pre_condition do
    "include mysql::server"
  end

  let :params do
    {
      :password => 'mistralpass',
    }
  end

  shared_examples 'mistral::db::mysql' do
    it { is_expected.to contain_class('mistral::deps') }

    context 'with only required params' do
      it { should contain_openstacklib__db__mysql('mistral').with(
        :user     => 'mistral',
        :password => 'mistralpass',
        :dbname   => 'mistral',
        :host     => '127.0.0.1',
        :charset  => 'utf8',
        :collate  => 'utf8_general_ci',
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
