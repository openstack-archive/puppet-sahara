require 'spec_helper'

describe 'sahara::service::api' do

  shared_examples 'sahara-api eventlet' do
    context 'with default params' do

      it {
        should contain_class('sahara::deps')
        should contain_class('sahara::policy')
        should contain_class('sahara::params')
      }

      it { should contain_package('sahara-api').with(
        :ensure => 'present',
        :name   => platform_params[:api_package_name],
        :tag    => ['openstack', 'sahara-package'],
      )}

      it { should contain_sahara_config('DEFAULT/api_workers').with_value(2) }

      it { should contain_service('sahara-api').with(
        :ensure     => 'running',
        :name       => platform_params[:api_service_name],
        :enable     => true,
        :hasstatus  => true,
        :hasrestart => true,
        :tag        => 'sahara-service',
      )}
    end

    context 'with custom params' do
      let :params do
        {
          :api_workers    => '4',
          :enabled        => false,
          :package_ensure => 'absent',
          :manage_service => false,
        }
      end

      it { should contain_package('sahara-api').with(
        :ensure => 'absent',
        :name   => platform_params[:api_package_name],
        :tag    => ['openstack', 'sahara-package'],
      )}

      it { should contain_sahara_config('DEFAULT/api_workers').with_value(4) }

      it { should_not contain_service('sahara-api') }
    end
  end

  shared_examples 'sahara-api eventlet ubuntu' do
    context 'with default params' do
      it { should raise_error(Puppet::Error, /The Sahara API must be run with WSGI on Ubuntu/) }
    end
  end

  shared_examples 'sahara-api wsgi' do
    let :pre_condition do
      'include apache'
    end

    let :params do
      {
        :service_name => 'httpd',
      }
    end

    context 'with default params' do
      it { should contain_package('sahara-api').with(
        :ensure => 'present',
        :name   => platform_params[:api_package_name],
        :tag    => ['openstack', 'sahara-package'],
      )}

      it { should contain_service('sahara-api').with(
        :ensure => 'stopped',
        :name   => platform_params[:api_service_name],
        :enable => false,
        :tag    => 'sahara-service',
      )}
    end
  end

  shared_examples 'sahara-api wsgi ubuntu' do
    let :pre_condition do
      'include apache'
    end

    let :params do
      {
        :service_name => 'httpd',
      }
    end

    context 'with default params' do
      it { should contain_package('sahara-api').with(
        :ensure => 'present',
        :name   => platform_params[:api_package_name],
        :tag    => ['openstack', 'sahara-package'],
      )}

      it { should_not contain_service('sahara-api') }
    end
  end

  on_supported_os({
    :supported_os => OSDefaults.get_supported_os
  }).each do |os,facts|
    context "on #{os}" do
      let (:facts) do
        facts.merge(OSDefaults.get_facts)
      end

      case facts[:os]['family']
      when 'Debian'
        let (:platform_params) do
          {
            :api_package_name => 'sahara-api',
            :api_service_name => 'sahara-api'
          }
        end
      when 'RedHat'
        let (:platform_params) do
          {
            :api_package_name => 'openstack-sahara-api',
            :api_service_name => 'openstack-sahara-api'
          }
        end
      end

      if facts[:os]['name'] == 'Ubuntu'
        it_behaves_like 'sahara-api eventlet ubuntu'
        it_behaves_like 'sahara-api wsgi ubuntu'
      else
        it_behaves_like 'sahara-api eventlet'
        it_behaves_like 'sahara-api wsgi'
      end

    end
  end

end
