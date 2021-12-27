require 'spec_helper'

describe 'sahara::db::sync' do

  shared_examples 'sahara-dbsync' do

    context 'default patameters' do

      it { is_expected.to contain_class('sahara::deps') }

      it 'runs sahara-dbmanage' do
        is_expected.to contain_exec('sahara-dbmanage').with(
          :command     => 'sahara-db-manage --config-file /etc/sahara/sahara.conf upgrade head',
          :path        => '/usr/bin',
          :user        => 'sahara',
          :refreshonly => 'true',
          :try_sleep   => 5,
          :tries       => 10,
          :timeout     => 300,
          :logoutput   => 'on_failure',
          :subscribe   => ['Anchor[sahara::install::end]',
                           'Anchor[sahara::config::end]',
                           'Anchor[sahara::dbsync::begin]'],
          :notify      => 'Anchor[sahara::dbsync::end]',
          :tag         => 'openstack-db',
        )
      end
    end

    context 'overriding params' do
      let :params do
        {
          :extra_params    => '--config-file /etc/sahara/sahara01.conf',
          :db_sync_timeout => 750,
        }
      end

      it {
        is_expected.to contain_exec('sahara-dbmanage').with(
          :command     => 'sahara-db-manage --config-file /etc/sahara/sahara01.conf upgrade head',
          :path        => '/usr/bin',
          :user        => 'sahara',
          :refreshonly => 'true',
          :try_sleep   => 5,
          :tries       => 10,
          :timeout     => 750,
          :logoutput   => 'on_failure',
          :subscribe   => ['Anchor[sahara::install::end]',
                           'Anchor[sahara::config::end]',
                           'Anchor[sahara::dbsync::begin]'],
          :notify      => 'Anchor[sahara::dbsync::end]',
          :tag         => 'openstack-db',
        )
        }
      end

  end

  on_supported_os({
    :supported_os   => OSDefaults.get_supported_os
  }).each do |os,facts|
    context "on #{os}" do
      let (:facts) do
        facts.merge(OSDefaults.get_facts({
          :concat_basedir => '/var/lib/puppet/concat'
        }))
      end

      it_configures 'sahara-dbsync'
    end
  end

end
