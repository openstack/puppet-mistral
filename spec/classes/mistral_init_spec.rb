require 'spec_helper'

describe 'mistral' do

  let :params do
    {
      :auth_uri          => 'http://127.0.0.1:5000/',
      :identity_uri      => 'http://127.0.0.1:35357/',
    }
  end

  shared_examples_for 'a mistral base installation' do

    it { is_expected.to contain_class('mistral::params') }

    it 'configures auth_uri' do
      is_expected.to contain_mistral_config('keystone_authtoken/auth_uri').with_value( params[:auth_uri] )
    end

    it 'configures identity_uri' do
      is_expected.to contain_mistral_config('keystone_authtoken/identity_uri').with_value( params[:identity_uri] )
    end

  end
end
