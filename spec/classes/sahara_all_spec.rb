require 'spec_helper'

describe 'sahara::service::all' do
  shared_examples 'sahara::service::all' do
    context 'with default params' do
      it {
        should contain_class('sahara::deps')
        should contain_class('sahara::policy')
        should contain_class('sahara::params')
      }

      it { should contain_package('sahara-all').with(
        :ensure => 'present',
        :name   => platform_params[:all_package_name],
        :tag    => ['openstack', 'sahara-package'],
      )}

      it { should contain_service('sahara-all').with(
        :ensure     => 'running',
        :name       => platform_params[:all_service_name],
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

      it { should contain_package('sahara-all').with(
        :ensure => 'absent',
        :name   => platform_params[:all_package_name],
        :tag    => ['openstack', 'sahara-package'],
      )}

      it { should contain_service('sahara-all').with(
        :ensure     => nil,
        :name       => platform_params[:all_service_name],
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
            :all_package_name => 'sahara',
            :all_service_name => 'sahara'
          }
        end
      when 'RedHat'
        let (:platform_params) do
          {
            :all_package_name => 'openstack-sahara',
            :all_service_name => 'openstack-sahara-all'
          }
        end
      end

      it_behaves_like 'sahara::service::all'
    end
  end

end
