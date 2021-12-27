#
# Unit tests for sahara::db::mysql
#
require 'spec_helper'

describe 'sahara::db::mysql' do

  let :pre_condition do
    ['include mysql::server']
  end

  let :params do
    { :dbname        => 'sahara',
      :password      => 'saharapass',
      :user          => 'sahara',
      :charset       => 'utf8',
      :collate       => 'utf8_general_ci',
      :host          => '127.0.0.1',
    }
  end

  shared_examples 'sahara mysql database' do
    it { should contain_class('sahara::deps') }

    context 'when omiting the required parameter password' do
      before { params.delete(:password) }
      it { expect { is_expected.to raise_error(Puppet::Error) } }
    end

    it 'creates a mysql database' do
      is_expected.to contain_openstacklib__db__mysql('sahara').with(
        :user          => params[:user],
        :dbname        => params[:dbname],
        :password      => params[:password],
        :host          => params[:host],
        :charset       => params[:charset]
      )
    end

    context 'overriding allowed_hosts param to array' do
      before :each do
        params.merge!(
          :allowed_hosts  => ['127.0.0.1','%']
        )
      end

      it {
        is_expected.to contain_openstacklib__db__mysql('sahara').with(
          :user          => params[:user],
          :dbname        => params[:dbname],
          :password      => params[:password],
          :host          => params[:host],
          :charset       => params[:charset],
          :allowed_hosts => ['127.0.0.1','%']
      )}
    end

    context 'overriding allowed_hosts param to string' do
      before :each do
        params.merge!(
          :allowed_hosts  => '192.168.1.1'
        )
      end

      it {
        is_expected.to contain_openstacklib__db__mysql('sahara').with(
          :user          => params[:user],
          :dbname        => params[:dbname],
          :password      => params[:password],
          :host          => params[:host],
          :charset       => params[:charset],
          :allowed_hosts => '192.168.1.1'
      )}
    end

  end

  on_supported_os({
    :supported_os   => OSDefaults.get_supported_os
  }).each do |os,facts|
    context "on #{os}" do
      let (:facts) do
        facts.merge(OSDefaults.get_facts)
      end
      it_configures 'sahara mysql database'
    end
  end

end
