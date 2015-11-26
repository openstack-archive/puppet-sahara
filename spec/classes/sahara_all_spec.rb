require 'spec_helper'

describe 'sahara::service::all' do

  shared_examples_for 'sahara-all' do
    context 'require main class' do
      it { is_expected.to contain_class('sahara') }
    end
  end

  context 'on Debian platforms' do
    let :facts do
      @default_facts.merge({
        :osfamily => 'Debian',
        :operatingsystem => 'Debian'
      })
    end

    it_configures 'sahara-all'

    it_behaves_like 'generic sahara service', {
       :name         => 'sahara-all',
       :package_name => 'sahara',
       :service_name => 'sahara' }
  end

  context 'on RedHat platforms' do
    let :facts do
      @default_facts.merge({ :osfamily => 'RedHat' })
    end

    it_configures 'sahara-all'

    it_behaves_like 'generic sahara service', {
       :name         => 'sahara-all',
       :package_name => 'openstack-sahara',
       :service_name => 'openstack-sahara-all' }
  end
end
