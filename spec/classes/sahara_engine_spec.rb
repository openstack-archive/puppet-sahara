require 'spec_helper'

describe 'sahara::service::engine' do
  shared_examples 'sahara::service::engine' do
    context 'with default params' do
      it {
        should contain_class('sahara::deps')
        should contain_class('sahara::params')
      }

      it { should contain_package('sahara-engine').with(
        :ensure => 'present',
        :name   => platform_params[:engine_package_name],
        :tag    => ['openstack', 'sahara-package'],
      )}

      it { should contain_service('sahara-engine').with(
        :ensure     => 'running',
        :name       => platform_params[:engine_service_name],
        :enable     => true,
        :hasstatus  => true,
        :hasrestart => true,
        :tag        => 'sahara-service',
      )}
    end

    context 'with custom params' do
      let :params do
        {
          :enabled        => false,
          :manage_service => false,
          :package_ensure => 'absent',
        }
      end

      it { should contain_package('sahara-engine').with(
        :ensure => 'absent',
        :name   => platform_params[:engine_package_name],
        :tag    => ['openstack', 'sahara-package'],
      )}

      it { should contain_service('sahara-engine').with(
        :ensure     => nil,
        :name       => platform_params[:engine_service_name],
        :enable     => false,
        :hasstatus  => true,
        :hasrestart => true,
        :tag        => 'sahara-service',
      )}
    end
  end

  on_supported_os({
    :supported_os => OSDefaults.get_supported_os
  }).each do |os,facts|
    context "on #{os}" do
      let (:facts) do
        facts.merge(OSDefaults.get_facts)
      end

      case facts[:osfamily]
      when 'Debian'
        let (:platform_params) do
          {
            :engine_package_name => 'sahara-engine',
            :engine_service_name => 'sahara-engine'
          }
        end
      when 'RedHat'
        let (:platform_params) do
          {
            :engine_package_name => 'openstack-sahara-engine',
            :engine_service_name => 'openstack-sahara-engine'
          }
        end
      end

      it_behaves_like 'sahara::service::engine'
    end
  end

end
