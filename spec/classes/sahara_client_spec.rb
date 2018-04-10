#
# Unit tests for sahara::client
#
require 'spec_helper'

describe 'sahara::client' do

  shared_examples_for 'sahara client' do

    context 'with default parameters' do
      it { is_expected.to contain_package('python-saharaclient').with(
        :ensure => 'present',
        :tag    => 'openstack',
        )
      }
    end

    context 'with package_ensure parameter provided' do
      let :params do
        { :package_ensure => false }
      end
      it { is_expected.to contain_package('python-saharaclient').with(
        :ensure => false,
        :name   => platform_params[:client_package_name],
        :tag    => 'openstack',
        )
      }
    end

  end

  on_supported_os({
    :supported_os   => OSDefaults.get_supported_os
  }).each do |os,facts|
    context "on #{os}" do
      let (:facts) do
        facts.merge(OSDefaults.get_facts)
      end

      let(:platform_params) do
        case facts[:osfamily]
        when 'Debian'
          if facts[:os_package_type] == 'debian'
            { :client_package_name => 'python3-saharaclient' }
          else
            { :client_package_name => 'python-saharaclient' }
          end
        when 'RedHat'
          { :client_package_name => 'python-saharaclient' }
        end
      end

      it_configures 'sahara client'
    end
  end

end
