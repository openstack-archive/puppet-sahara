#
# Unit tests for sahara::keystone::auth
#

require 'spec_helper'

describe 'sahara::keystone::auth' do
  shared_examples 'sahara::keystone::auth' do
    context 'with default class parameters' do
      let :params do
        { :password => 'sahara_password' }
      end

      it { is_expected.to contain_keystone__resource__service_identity('sahara').with(
        :configure_user      => true,
        :configure_user_role => true,
        :configure_endpoint  => true,
        :service_name        => 'sahara',
        :service_type        => 'data-processing',
        :service_description => 'Sahara Data Processing',
        :region              => 'RegionOne',
        :auth_name           => 'sahara',
        :password            => 'sahara_password',
        :email               => 'sahara@localhost',
        :tenant              => 'services',
        :roles               => ['admin'],
        :system_scope        => 'all',
        :system_roles        => [],
        :public_url          => 'http://127.0.0.1:8386',
        :internal_url        => 'http://127.0.0.1:8386',
        :admin_url           => 'http://127.0.0.1:8386',
      ) }
    end

    context 'when overriding parameters' do
      let :params do
        { :password            => 'sahara_password',
          :auth_name           => 'alt_sahara',
          :email               => 'alt_sahara@alt_localhost',
          :tenant              => 'alt_service',
          :roles               => ['admin', 'service'],
          :system_scope        => 'alt_all',
          :system_roles        => ['admin', 'member', 'reader'],
          :configure_endpoint  => false,
          :configure_user      => false,
          :configure_user_role => false,
          :service_description => 'Alternative Sahara Data Processing',
          :service_name        => 'alt_service',
          :service_type        => 'alt_data-processing',
          :region              => 'RegionTwo',
          :public_url          => 'https://10.10.10.10:80',
          :internal_url        => 'http://10.10.10.11:81',
          :admin_url           => 'http://10.10.10.12:81' }
      end

      it { is_expected.to contain_keystone__resource__service_identity('sahara').with(
        :configure_user      => false,
        :configure_user_role => false,
        :configure_endpoint  => false,
        :service_name        => 'alt_service',
        :service_type        => 'alt_data-processing',
        :service_description => 'Alternative Sahara Data Processing',
        :region              => 'RegionTwo',
        :auth_name           => 'alt_sahara',
        :password            => 'sahara_password',
        :email               => 'alt_sahara@alt_localhost',
        :tenant              => 'alt_service',
        :roles               => ['admin', 'service'],
        :system_scope        => 'alt_all',
        :system_roles        => ['admin', 'member', 'reader'],
        :public_url          => 'https://10.10.10.10:80',
        :internal_url        => 'http://10.10.10.11:81',
        :admin_url           => 'http://10.10.10.12:81',
      ) }
    end
  end

  on_supported_os({
    :supported_os => OSDefaults.get_supported_os
  }).each do |os,facts|
    context "on #{os}" do
      let (:facts) do
        facts.merge!(OSDefaults.get_facts())
      end

      it_behaves_like 'sahara::keystone::auth'
    end
  end
end
