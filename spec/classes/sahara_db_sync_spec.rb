require 'spec_helper'

describe 'sahara::db::sync' do

  shared_examples_for 'sahara-dbsync' do

    it 'runs sahara-dbmanage' do
      is_expected.to contain_exec('sahara-dbmanage').with(
        :command     => 'sahara-db-manage --config-file /etc/sahara/sahara.conf upgrade head',
        :path        => '/usr/bin',
        :user        => 'sahara',
        :refreshonly => 'true',
        :logoutput   => 'on_failure'
      )
    end

    describe 'overriding extra_params' do
      let :params do
        {
          :extra_params => '--config-file /etc/sahara/sahara01.conf',
        }
      end

      it {
        is_expected.to contain_exec('sahara-dbmanage').with(
          :command     => 'sahara-db-manage --config-file /etc/sahara/sahara01.conf upgrade head',
          :path        => '/usr/bin',
          :user        => 'sahara',
          :refreshonly => 'true',
          :logoutput   => 'on_failure'
        )
        }
      end

  end


  context 'on a RedHat osfamily' do
    let :facts do
      {
        :osfamily                 => 'RedHat',
        :operatingsystemrelease   => '7.0',
        :concat_basedir => '/var/lib/puppet/concat'
      }
    end

    it_configures 'sahara-dbsync'
  end

  context 'on a Debian osfamily' do
    let :facts do
      {
        :operatingsystemrelease => '7.8',
        :operatingsystem        => 'Debian',
        :osfamily               => 'Debian',
        :concat_basedir => '/var/lib/puppet/concat'
      }
    end

    it_configures 'sahara-dbsync'
  end

end
