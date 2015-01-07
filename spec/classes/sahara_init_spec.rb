#
# Unit tests for sahara::init
#
require 'spec_helper'

describe 'sahara' do

  let :params do
    {
      :keystone_password => 'secrete'
    }
  end

  shared_examples_for 'sahara' do
    it { should contain_class('sahara::params') }
    it { should contain_class('mysql::bindings::python') }
    it { should contain_exec('sahara-dbmanage') }
  end

  context 'on Debian platforms' do
    let :facts do
      {
        :osfamily => 'Debian',
        :operatingsystem => 'Debian'
      }
    end

    it_configures 'sahara'

    it_behaves_like 'generic sahara service', {
      :name         => 'sahara',
      :package_name => 'sahara',
      :service_name => 'sahara' }
  end

  context 'on RedHat platforms' do
    let :facts do
      { :osfamily => 'RedHat' }
    end

    it_configures 'sahara'

    it_behaves_like 'generic sahara service', {
      :name         => 'sahara',
      :package_name => 'openstack-sahara',
      :service_name => 'openstack-sahara-all' }

  end
end
