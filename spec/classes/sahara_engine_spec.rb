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

      it 'should configure default coordination parameters' do
        should contain_oslo__coordination('sahara_config').with(
          :backend_url   => '<SERVICE DEFAULT>',
          :manage_config => false,
        )

        should contain_sahara_config('DEFAULT/periodic_coordinator_backend_url').with_value('<SERVICE DEFAULT>')
        should contain_sahara_config('DEFAULT/periodic_workers_number').with_value('<SERVICE DEFAULT>')
      end
    end

    context 'with custom params' do
      let :params do
        {
          :enabled                          => false,
          :manage_service                   => false,
          :package_ensure                   => 'absent',
          :periodic_coordinator_backend_url => 'etcd3+http://127.0.0.1:2379',
          :periodic_workers_number          => 4,
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

      it 'should configure default coordination parameters' do
        should contain_oslo__coordination('sahara_config').with(
          :backend_url   => 'etcd3+http://127.0.0.1:2379',
          :manage_config => false,
        )

        should contain_sahara_config('DEFAULT/periodic_coordinator_backend_url').with_value('etcd3+http://127.0.0.1:2379')
        should contain_sahara_config('DEFAULT/periodic_workers_number').with_value(4)
      end
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
