require 'spec_helper'

describe 'sahara::service::engine' do

  context 'on Debian platforms' do
    let :facts do
      @default_facts.merge({ :osfamily => 'Debian' })
    end

    it_behaves_like 'generic sahara service', {
       :name         => 'sahara-engine',
       :package_name => 'sahara-engine',
       :service_name => 'sahara-engine' }
  end

  context 'on RedHat platforms' do
    let :facts do
      @default_facts.merge({ :osfamily => 'RedHat' })
    end

    it_behaves_like 'generic sahara service', {
       :name         => 'sahara-engine',
       :package_name => 'openstack-sahara-engine',
       :service_name => 'openstack-sahara-engine' }
  end

end
