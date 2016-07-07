require 'spec_helper'

describe 'sahara::service::api' do

  shared_examples_for 'sahara-api' do

    context 'default params' do
      it { is_expected.to contain_sahara_config('DEFAULT/api_workers').with_value('<SERVICE DEFAULT>') }
    end

    context 'passing params' do
      let :params do
      {
        :api_workers => '2',
      }
      end

      it { is_expected.to contain_sahara_config('DEFAULT/api_workers').with_value('2') }
    end

  end

  on_supported_os({
    :supported_os   => OSDefaults.get_supported_os
  }).each do |os,facts|
    context "on #{os}" do
      let (:facts) do
        facts.merge(OSDefaults.get_facts)
      end

      case facts[:osfamily]
      when 'Debian'
        platform_params = {
          :name         => 'sahara-api',
          :package_name => 'sahara-api',
          :service_name => 'sahara-api' }
      when 'RedHat'
        platform_params = {
          :name         => 'sahara-api',
          :package_name => 'openstack-sahara-api',
          :service_name => 'openstack-sahara-api' }
      end

      it_configures 'sahara-api'
      it_behaves_like 'generic sahara service', platform_params
    end
  end

end
