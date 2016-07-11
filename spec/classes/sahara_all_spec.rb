require 'spec_helper'

describe 'sahara::service::all' do

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
          :name         => 'sahara-all',
          :package_name => 'sahara',
          :service_name => 'sahara' }
      when 'RedHat'
        platform_params = {
          :name         => 'sahara-all',
          :package_name => 'openstack-sahara',
          :service_name => 'openstack-sahara-all' }
      end

      it_behaves_like 'generic sahara service', platform_params
    end
  end

end
