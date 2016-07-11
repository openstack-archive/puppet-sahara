#
# Unit tests for sahara::keystone::auth
#
require 'spec_helper'

describe 'sahara::keystone::auth' do

  shared_examples_for 'sahara-keystone-auth' do
    context 'with default class parameters' do
      let :params do
        { :password => 'sahara_password',
          :tenant   => 'foobar' }
      end

      it { is_expected.to contain_keystone_user('sahara').with(
        :ensure   => 'present',
        :password => 'sahara_password',
      ) }

      it { is_expected.to contain_keystone_user_role('sahara@foobar').with(
        :ensure  => 'present',
        :roles   => ['admin']
      )}

      it { is_expected.to contain_keystone_service('sahara::data-processing').with(
        :ensure      => 'present',
        :description => 'Sahara Data Processing'
      ) }

      it { is_expected.to contain_keystone_endpoint('RegionOne/sahara::data-processing').with(
        :ensure       => 'present',
        :public_url   => "http://127.0.0.1:8386/v1.1/%(tenant_id)s",
        :admin_url    => "http://127.0.0.1:8386/v1.1/%(tenant_id)s",
        :internal_url => "http://127.0.0.1:8386/v1.1/%(tenant_id)s"
      ) }
    end

    context 'when configuring sahara-server' do
      let :pre_condition do
        "class { 'sahara::server': auth_password => 'test' }"
      end

      let :params do
        { :password => 'sahara_password',
          :tenant   => 'foobar' }
      end
    end

    context 'with endpoint parameters' do
      let :params do
        { :password     => 'sahara_password',
          :public_url   => 'https://10.10.10.10:80/v1.1/%(tenant_id)s',
          :internal_url => 'http://10.10.10.11:81/v1.1/%(tenant_id)s',
          :admin_url    => 'http://10.10.10.12:81/v1.1/%(tenant_id)s' }
      end

      it { is_expected.to contain_keystone_endpoint('RegionOne/sahara::data-processing').with(
        :ensure       => 'present',
        :public_url   => 'https://10.10.10.10:80/v1.1/%(tenant_id)s',
        :internal_url => 'http://10.10.10.11:81/v1.1/%(tenant_id)s',
        :admin_url    => 'http://10.10.10.12:81/v1.1/%(tenant_id)s'
      ) }
    end

    context 'when overriding auth name' do
      let :params do
        { :password => 'foo',
          :auth_name => 'saharay' }
      end

      it { is_expected.to contain_keystone_user('saharay') }
      it { is_expected.to contain_keystone_user_role('saharay@services') }
      it { is_expected.to contain_keystone_service('sahara::data-processing') }
      it { is_expected.to contain_keystone_endpoint('RegionOne/sahara::data-processing') }
    end
  end

  on_supported_os({
    :supported_os   => OSDefaults.get_supported_os
  }).each do |os,facts|
    context "on #{os}" do
      let (:facts) do
        facts.merge(OSDefaults.get_facts)
      end
      it_configures 'sahara-keystone-auth'
    end
  end

end
