require 'spec_helper'

describe 'sahara::service::all' do

  context 'on Debian platforms' do
    let :facts do
      @default_facts.merge({
        :osfamily => 'Debian',
        :operatingsystem => 'Debian'
      })
    end

    it_behaves_like 'generic sahara service', {
       :name         => 'sahara-all',
       :package_name => 'sahara',
       :service_name => 'sahara' }
  end

  context 'on RedHat platforms' do
    let :facts do
      @default_facts.merge({ :osfamily => 'RedHat' })
    end

    it_behaves_like 'generic sahara service', {
       :name         => 'sahara-all',
       :package_name => 'openstack-sahara',
       :service_name => 'openstack-sahara-all' }
  end
end
