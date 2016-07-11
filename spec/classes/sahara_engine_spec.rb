require 'spec_helper'

describe 'sahara::service::engine' do

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
          :name         => 'sahara-engine',
          :package_name => 'sahara-engine',
          :service_name => 'sahara-engine' }
      when 'RedHat'
        platform_params = {
          :name         => 'sahara-engine',
          :package_name => 'openstack-sahara-engine',
          :service_name => 'openstack-sahara-engine' }
      end

      it_behaves_like 'generic sahara service', platform_params
    end
  end

end
