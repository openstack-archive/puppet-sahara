#
# Unit tests for sahara::init
#
require 'spec_helper'

describe 'sahara' do

  let :params do
    {
      :admin_password => 'secrete'
    }
  end

  shared_examples_for 'sahara' do
    it { is_expected.to contain_class('sahara::params') }
    it { is_expected.to contain_class('sahara::policy') }
    it { is_expected.to contain_class('mysql::bindings::python') }
    it { is_expected.to contain_exec('sahara-dbmanage') }
  end

  shared_examples_for 'sahara config' do
    context 'with default params' do
      it { is_expected.to contain_sahara_config('DEFAULT/use_neutron').with_value('false') }
      it { is_expected.to contain_sahara_config('DEFAULT/use_floating_ips').with_value('true') }
      it { is_expected.to contain_sahara_config('DEFAULT/host').with_value('0.0.0.0') }
      it { is_expected.to contain_sahara_config('DEFAULT/port').with_value('8386') }
      it { is_expected.to contain_sahara_config('keystone_authtoken/auth_uri').with_value('http://127.0.0.1:5000/v2.0/') }
      it { is_expected.to contain_sahara_config('keystone_authtoken/identity_uri').with_value('http://127.0.0.1:35357/') }
      it { is_expected.to contain_sahara_config('keystone_authtoken/admin_user').with_value('admin') }
      it { is_expected.to contain_sahara_config('keystone_authtoken/admin_tenant_name').with_value('admin') }
      it { is_expected.to contain_sahara_config('keystone_authtoken/admin_password').with_value('secrete').with_secret(true) }
    end

    context 'with passing params' do
      let :params do {
        :use_neutron       => 'true',
        :host              => 'localhost',
        :port              => '8387',
        :auth_uri          => 'http://8.8.8.8:5000/v2.0/',
        :identity_uri      => 'http://8.8.8.8:35357/',
        :admin_user        => 'sahara',
        :admin_tenant_name => 'sahara-tenant',
        :admin_password    => 'new_password',
      }
      end

      it { is_expected.to contain_sahara_config('DEFAULT/use_neutron').with_value('true') }
      it { is_expected.to contain_sahara_config('DEFAULT/host').with_value('localhost') }
      it { is_expected.to contain_sahara_config('DEFAULT/port').with_value('8387') }
      it { is_expected.to contain_sahara_config('keystone_authtoken/auth_uri').with_value('http://8.8.8.8:5000/v2.0/') }
      it { is_expected.to contain_sahara_config('keystone_authtoken/identity_uri').with_value('http://8.8.8.8:35357/') }
      it { is_expected.to contain_sahara_config('keystone_authtoken/admin_user').with_value('sahara') }
      it { is_expected.to contain_sahara_config('keystone_authtoken/admin_tenant_name').with_value('sahara-tenant') }
      it { is_expected.to contain_sahara_config('keystone_authtoken/admin_password').with_value('new_password').with_secret(true) }
    end

    context 'with deprecated params' do
      let :params do {
        :service_host      => 'localhost',
        :service_port      => '8387',
        :keystone_url      => 'http://8.8.8.8:5000/v2.0/',
        :identity_url      => 'http://8.8.8.8:35357/',
        :keystone_username => 'sahara',
        :keystone_tenant   => 'sahara-tenant',
        :keystone_password => 'new_password',
      }
      end

      it { is_expected.to contain_sahara_config('DEFAULT/host').with_value('localhost') }
      it { is_expected.to contain_sahara_config('DEFAULT/port').with_value('8387') }
      it { is_expected.to contain_sahara_config('keystone_authtoken/auth_uri').with_value('http://8.8.8.8:5000/v2.0/') }
      it { is_expected.to contain_sahara_config('keystone_authtoken/identity_uri').with_value('http://8.8.8.8:35357/') }
      it { is_expected.to contain_sahara_config('keystone_authtoken/admin_user').with_value('sahara') }
      it { is_expected.to contain_sahara_config('keystone_authtoken/admin_tenant_name').with_value('sahara-tenant') }
      it { is_expected.to contain_sahara_config('keystone_authtoken/admin_password').with_value('new_password').with_secret(true) }
    end
  end

  shared_examples_for 'sahara logging' do
    context 'with use_stderr enabled' do
      it { is_expected.to contain_sahara_config('DEFAULT/use_stderr').with_value(true) }
    end

    context 'with syslog disabled' do
      it { is_expected.to contain_sahara_config('DEFAULT/use_syslog').with_value(false) }
    end

    context 'with syslog enabled' do
      let :params do
        { :use_syslog   => 'true' }
      end

      it { is_expected.to contain_sahara_config('DEFAULT/use_syslog').with_value(true) }
      it { is_expected.to contain_sahara_config('DEFAULT/syslog_log_facility').with_value('LOG_USER') }
    end

    context 'with syslog enabled and custom settings' do
      let :params do
        {
          :use_syslog   => 'true',
          :log_facility => 'LOG_LOCAL0'
        }
      end

      it { is_expected.to contain_sahara_config('DEFAULT/use_syslog').with_value(true) }
      it { is_expected.to contain_sahara_config('DEFAULT/syslog_log_facility').with_value('LOG_LOCAL0') }
    end

    context 'with log_dir disabled' do
      let :params do
        { :log_dir => false }
      end
      it { is_expected.to contain_sahara_config('DEFAULT/log_dir').with_ensure('absent') }
    end

  end

  shared_examples_for 'sahara ssl' do
    context 'without ssl' do
      it { is_expected.to contain_sahara_config('ssl/ca_file').with_ensure('absent') }
      it { is_expected.to contain_sahara_config('ssl/cert_file').with_ensure('absent') }
      it { is_expected.to contain_sahara_config('ssl/key_file').with_ensure('absent') }
    end

    context 'with ssl' do
      let :params do
      {
        :use_ssl   => 'true',
        :ca_file   => '/tmp/ca_file',
        :cert_file => '/tmp/cert_file',
        :key_file  => '/tmp/key_file',
      }
      end
      it { is_expected.to contain_sahara_config('ssl/ca_file').with_value('/tmp/ca_file') }
      it { is_expected.to contain_sahara_config('ssl/cert_file').with_value('/tmp/cert_file') }
      it { is_expected.to contain_sahara_config('ssl/key_file').with_value('/tmp/key_file') }
    end

    context 'with ssl but without ca_file' do
      let :params do
      {
        :use_ssl   => 'true',
      }
      end
      it_raises 'a Puppet::Error', /The ca_file parameter is required when use_ssl is set to true/
    end

    context 'with ssl but without cert_file' do
      let :params do
      {
        :use_ssl   => 'true',
        :ca_file   => '/tmp/ca_file',
      }
      end
      it_raises 'a Puppet::Error', /The cert_file parameter is required when use_ssl is set to true/
    end

    context 'with ssl but without key_file' do
      let :params do
      {
        :use_ssl   => 'true',
        :ca_file   => '/tmp/ca_file',
        :cert_file => '/tmp/cert_file',
      }
      end
      it_raises 'a Puppet::Error', /The key_file parameter is required when use_ssl is set to true/
    end
  end

  context 'on Debian platforms' do
    let :facts do
      {
        :osfamily => 'Debian',
        :operatingsystem => 'Debian'
      }
    end

    it_configures 'sahara'
    it_configures 'sahara config'
    it_configures 'sahara logging'
    it_configures 'sahara ssl'

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
    it_configures 'sahara config'
    it_configures 'sahara logging'
    it_configures 'sahara ssl'

    it_behaves_like 'generic sahara service', {
      :name         => 'sahara',
      :package_name => 'openstack-sahara',
      :service_name => 'openstack-sahara-all' }

  end
end
