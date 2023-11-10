require 'spec_helper'

describe 'sahara::plugin' do
  let(:title) {'vanilla'}

  shared_examples_for 'sahara::plugin' do

    context 'with default parameters' do

      it 'installs the plugin package' do
        is_expected.to contain_package('sahara-plugin-vanilla').with(
          :ensure => 'present',
          :name   => 'python3-sahara-plugin-vanilla',
          :tag    => ['openstack', 'sahara-package'],
        )
      end
    end
  end

  on_supported_os({
    :supported_os   => OSDefaults.get_supported_os
  }).each do |os,facts|
    context "on #{os}" do
      let (:facts) do
        facts.merge!(OSDefaults.get_facts())
      end

      it_configures 'sahara::plugin'
    end
  end

end
