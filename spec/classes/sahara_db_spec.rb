require 'spec_helper'

describe 'sahara::db' do

  shared_examples 'sahara::db' do
    context 'with default parameters' do
      it { is_expected.to contain_oslo__db('sahara_config').with(
        :db_max_retries => '<SERVICE DEFAULT>',
        :connection     => 'mysql+pymysql://sahara:secrete@localhost:3306/sahara',
        :idle_timeout   => '<SERVICE DEFAULT>',
        :min_pool_size  => '<SERVICE DEFAULT>',
        :max_pool_size  => '<SERVICE DEFAULT>',
        :max_retries    => '<SERVICE DEFAULT>',
        :retry_interval => '<SERVICE DEFAULT>',
        :max_overflow   => '<SERVICE DEFAULT>',
      )}
    end

    context 'with specific parameters' do
      let :params do
        { :database_db_max_retries => '-1',
          :database_connection     => 'mysql+pymysql://sahara:sahara@localhost/sahara',
          :database_idle_timeout   => '3601',
          :database_min_pool_size  => '2',
          :database_max_retries    => '11',
          :database_retry_interval => '11',
          :database_max_pool_size  => '11',
          :database_max_overflow   => '21',
        }
      end

      it { is_expected.to contain_oslo__db('sahara_config').with(
        :db_max_retries => '-1',
        :connection     => 'mysql+pymysql://sahara:sahara@localhost/sahara',
        :idle_timeout   => '3601',
        :min_pool_size  => '2',
        :max_pool_size  => '11',
        :max_retries    => '11',
        :retry_interval => '11',
        :max_overflow   => '21',
      )}
    end

    context 'with MySQL-python library as backend package' do
      let :params do
        { :database_connection => 'mysql://sahara:sahara@localhost/sahara' }
      end

      it { is_expected.to contain_oslo__db('sahara_config').with(
        :connection => 'mysql://sahara:sahara@localhost/sahara',
      )}
    end

    context 'with postgresql backend' do
      let :params do
        { :database_connection => 'postgresql://sahara:sahara@localhost/sahara', }
      end

      it 'install the proper backend package' do
        is_expected.to contain_package('python-psycopg2').with(:ensure => 'present')
      end

    end

    context 'with incorrect database_connection string' do
      let :params do
        { :database_connection => 'sqlite://sahara:sahara@localhost/sahara', }
      end

      it_raises 'a Puppet::Error', /validate_re/
    end

    context 'with incorrect database_connection string' do
      let :params do
        { :database_connection => 'foo+pymysql://sahara:sahara@localhost/sahara', }
      end

      it_raises 'a Puppet::Error', /validate_re/
    end
  end

  shared_examples_for 'sahara::db on Debian' do
    context 'using pymysql driver' do
      let :params do
        { :database_connection => 'mysql+pymysql://sahara:sahara@localhost/sahara', }
      end

      it 'install the proper backend package' do
        is_expected.to contain_package('python-pymysql').with(
          :ensure => 'present',
          :name   => 'python-pymysql',
          :tag    => 'openstack'
        )
      end
    end
  end

  shared_examples_for 'sahara::db on RedHat' do
    context 'using pymysql driver' do
      let :params do
        { :database_connection => 'mysql+pymysql://sahara:sahara@localhost/sahara', }
      end

    end
  end

  on_supported_os({
    :supported_os => OSDefaults.get_supported_os
  }).each do |os,facts|
    context "on #{os}" do
      let (:facts) do
        facts.merge!(OSDefaults.get_facts())
      end

      case facts[:osfamily]
      when 'Debian'
        it_configures 'sahara::db on Debian'
      when 'RedHat'
        it_configures 'sahara::db on RedHat'
      end
      it_configures 'sahara::db'
    end
  end

end
