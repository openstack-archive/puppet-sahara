require 'puppet'
require 'spec_helper'
require 'puppet/provider/sahara'
require 'tempfile'

klass = Puppet::Provider::Sahara

describe Puppet::Provider::Sahara do

  after :each do
    klass.reset
  end

  describe 'when retrieving the auth credentials' do

    it 'should fail if no auth params are passed and the glance config file does not have the expected contents' do
      mock = {}
      Puppet::Util::IniConfig::File.expects(:new).returns(mock)
      mock.expects(:read).with('/etc/sahara/sahara.conf')
      expect do
        klass.sahara_credentials
      end.to raise_error(Puppet::Error, /Can not to authenticate Sahara/)
    end

    it 'should read conf file with all sections' do
      creds_hash = {
        'auth_uri'          => 'https://192.168.56.210:35357/v2.0/',
        'admin_tenant_name' => 'admin_tenant',
        'admin_user'        => 'admin',
        'admin_password'    => 'password',
      }
      mock = {
        'keystone_authtoken' => {
          'auth_uri'          => 'https://192.168.56.210:35357/v2.0/',
          'admin_tenant_name' => 'admin_tenant',
          'admin_user'        => 'admin',
          'admin_password'    => 'password',
        }
      }
      Puppet::Util::IniConfig::File.expects(:new).returns(mock)
      mock.expects(:read).with('/etc/sahara/sahara.conf')
      expect(klass.sahara_credentials).to eq(creds_hash)
    end

  end
end
