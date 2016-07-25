require 'spec_helper'

describe 'mistral::client' do
  on_supported_os.each do |os, facts|
    let(:facts) { facts }
    context "on #{os}" do
      it { is_expected.to contain_package('python-mistralclient')
                           .with(:ensure => 'present',
                                 :tag    => ['openstack',
                                             'mistral-package']) }
    end
  end
end
