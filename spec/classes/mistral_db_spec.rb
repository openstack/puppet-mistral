require 'spec_helper'

describe 'mistral::db' do

  shared_examples 'mistral::db' do

    context 'with default parameters' do

      it { is_expected.to contain_oslo__db('mistral_config').with(
        :db_max_retries => '<SERVICE DEFAULT>',
        :connection     => 'sqlite:////var/lib/mistral/mistral.sqlite',
        :idle_timeout   => '<SERVICE DEFAULT>',
        :min_pool_size  => '<SERVICE DEFAULT>',
        :max_pool_size  => '<SERVICE DEFAULT>',
        :max_retries    => '<SERVICE DEFAULT>',
        :retry_interval => '<SERVICE DEFAULT>',
        :max_overflow   => '<SERVICE DEFAULT>',
        :pool_timeout   => '<SERVICE DEFAULT>',
      )}

    end

    context 'with specific parameters' do
      let :params do
        { :database_connection     => 'mysql+pymysql://mistral:mistral@localhost/mistral',
          :database_idle_timeout   => '3601',
          :database_min_pool_size  => '2',
          :database_max_pool_size  => '11',
          :database_max_retries    => '11',
          :database_retry_interval => '11', 
          :database_db_max_retries => '-1',
          :database_max_overflow   => '21', 
          :database_pool_timeout   => '21', 
        }
      end

      it { is_expected.to contain_oslo__db('mistral_config').with(
        :db_max_retries => '-1',
        :connection     => 'mysql+pymysql://mistral:mistral@localhost/mistral',
        :idle_timeout   => '3601',
        :min_pool_size  => '2',
        :max_pool_size  => '11',
        :max_retries    => '11',
        :retry_interval => '11',
        :max_overflow   => '21',
        :pool_timeout   => '21',
      )}
    end

    context 'with postgresql backend' do
      let :params do
        { :database_connection => 'postgresql://mistral:mistral@localhost/mistral', }
      end

      it 'install the proper backend package' do
        is_expected.to contain_package('python-psycopg2').with(:ensure => 'present')
      end

    end

    context 'with MySQL-python library as backend package' do
      let :params do
        { :database_connection => 'mysql://mistral:mistral@localhost/mistral', }
      end

      it { is_expected.to contain_package('python-mysqldb').with(:ensure => 'present') }
    end

    context 'with incorrect database_connection string' do
      let :params do
        { :database_connection => 'redis://mistral:mistral@localhost/mistral', }
      end

      it_raises 'a Puppet::Error', /validate_re/
    end

    context 'with incorrect pymysql database_connection string' do
      let :params do
        { :database_connection => 'foo+pymysql://mistral:mistral@localhost/mistral', }
      end

      it_raises 'a Puppet::Error', /validate_re/
    end

  end

  context 'on Debian platforms' do
    let :facts do
      OSDefaults.get_facts({
        :osfamily => 'Debian',
        :operatingsystem => 'Debian',
        :operatingsystemrelease => 'jessie'
      })
    end

    it_configures 'mistral::db'

    context 'using pymysql driver' do
      let :params do
        { :database_connection => 'mysql+pymysql://mistral:mistral@localhost/mistral', }
      end

      it 'install the proper backend package' do
        is_expected.to contain_package('python-pymysql').with(
          :ensure => 'present',
          :name   => 'python-pymysql',
          :tag    => ['openstack'],
        )
      end
    end


    context 'with sqlite backend' do
      let :params do
        { :database_connection => 'sqlite:///var/lib/mistral/mistral.sqlite', }
      end

      it 'install the proper backend package' do
        is_expected.to contain_package('python-pysqlite2').with(
          :ensure => 'present',
          :name   => 'python-pysqlite2',
          :tag    => ['openstack'],
        )
      end
    end

   end

  context 'on Redhat platforms' do
    let :facts do
      OSDefaults.get_facts({
        :osfamily => 'RedHat',
        :operatingsystemrelease => '7.1',
      })
    end

    it_configures 'mistral::db'

    context 'using pymysql driver' do
      let :params do
        { :database_connection => 'mysql+pymysql://mistral:mistral@localhost/mistral', }
      end

    end
  end

end
