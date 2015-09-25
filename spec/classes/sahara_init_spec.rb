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
    it { is_expected.to contain_class('sahara::db') }
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
      it { is_expected.to contain_sahara_config('keystone_authtoken/admin_user').with_value('sahara') }
      it { is_expected.to contain_sahara_config('keystone_authtoken/admin_tenant_name').with_value('services') }
      it { is_expected.to contain_sahara_config('keystone_authtoken/admin_password').with_value('secrete').with_secret(true) }
      it { is_expected.to contain_sahara_config('DEFAULT/plugins').with_ensure('absent') }
    end

    context 'with passing params' do
      let :params do {
        :use_neutron           => 'true',
        :host                  => 'localhost',
        :port                  => '8387',
        :auth_uri              => 'http://8.8.8.8:5000/v2.0/',
        :identity_uri          => 'http://8.8.8.8:35357/',
        :admin_user            => 'sahara-user',
        :admin_tenant_name     => 'sahara-tenant',
        :admin_password        => 'new_password',
        :plugins               => ['plugin1', 'plugin2'],
      }
      end

      it { is_expected.to contain_sahara_config('DEFAULT/use_neutron').with_value('true') }
      it { is_expected.to contain_sahara_config('DEFAULT/host').with_value('localhost') }
      it { is_expected.to contain_sahara_config('DEFAULT/port').with_value('8387') }
      it { is_expected.to contain_sahara_config('keystone_authtoken/auth_uri').with_value('http://8.8.8.8:5000/v2.0/') }
      it { is_expected.to contain_sahara_config('keystone_authtoken/identity_uri').with_value('http://8.8.8.8:35357/') }
      it { is_expected.to contain_sahara_config('keystone_authtoken/admin_user').with_value('sahara-user') }
      it { is_expected.to contain_sahara_config('keystone_authtoken/admin_tenant_name').with_value('sahara-tenant') }
      it { is_expected.to contain_sahara_config('keystone_authtoken/admin_password').with_value('new_password').with_secret(true) }
      it { is_expected.to contain_sahara_config('DEFAULT/plugins').with_value('plugin1,plugin2') }
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

  shared_examples_for 'sahara rpc_backend' do
    context 'with rabbit rpc' do
      before do
        params.merge!({ :rpc_backend => 'rabbit' })
      end
      it { is_expected.to contain_sahara_config('DEFAULT/rpc_backend').with_value('rabbit') }

      context 'when defaults with rabbit pass specified' do
         it { is_expected.to contain_sahara_config('oslo_messaging_rabbit/rabbit_password').with_value('guest').with_secret(true) }
         it { is_expected.to contain_sahara_config('oslo_messaging_rabbit/rabbit_userid').with_value('guest') }
         it { is_expected.to contain_sahara_config('oslo_messaging_rabbit/rabbit_host').with_value('localhost') }
         it { is_expected.to contain_sahara_config('oslo_messaging_rabbit/rabbit_port').with_value('5672') }
         it { is_expected.to contain_sahara_config('oslo_messaging_rabbit/rabbit_hosts').with_value('localhost:5672') }
         it { is_expected.to contain_sahara_config('oslo_messaging_rabbit/rabbit_ha_queues').with_value('false') }
         it { is_expected.to contain_sahara_config('oslo_messaging_rabbit/rabbit_virtual_host').with_value('/') }
         it { is_expected.to contain_sahara_config('oslo_messaging_rabbit/amqp_durable_queues').with_value('false') }
      end

      context 'when passing params' do
        before do
          params.merge!({
            :rabbit_password     => 'pass',
            :rabbit_userid       => 'guest2',
            :rabbit_host         => 'localhost2',
            :rabbit_port         => '5673',
            :rabbit_ha_queues    => 'true',
            :amqp_durable_queues => 'true',
          })
        end

        it { is_expected.to contain_sahara_config('oslo_messaging_rabbit/rabbit_userid').with_value('guest2') }
        it { is_expected.to contain_sahara_config('oslo_messaging_rabbit/rabbit_password').with_value('pass').with_secret(true) }
        it { is_expected.to contain_sahara_config('oslo_messaging_rabbit/rabbit_host').with_value('localhost2') }
        it { is_expected.to contain_sahara_config('oslo_messaging_rabbit/rabbit_port').with_value('5673') }
        it { is_expected.to contain_sahara_config('oslo_messaging_rabbit/rabbit_ha_queues').with_value('true') }
        it { is_expected.to contain_sahara_config('oslo_messaging_rabbit/amqp_durable_queues').with_value('true') }
      end

      context 'with rabbit ssl cert parameters' do
        before do
          params.merge!({
            :rabbit_password    => 'pass',
            :rabbit_use_ssl     => 'true',
            :kombu_ssl_ca_certs => '/etc/ca.cert',
            :kombu_ssl_certfile => '/etc/certfile',
            :kombu_ssl_keyfile  => '/etc/key',
          })
        end

        it { is_expected.to contain_sahara_config('oslo_messaging_rabbit/rabbit_use_ssl').with_value('true') }
        it { is_expected.to contain_sahara_config('oslo_messaging_rabbit/kombu_ssl_ca_certs').with_value('/etc/ca.cert') }
        it { is_expected.to contain_sahara_config('oslo_messaging_rabbit/kombu_ssl_certfile').with_value('/etc/certfile') }
        it { is_expected.to contain_sahara_config('oslo_messaging_rabbit/kombu_ssl_keyfile').with_value('/etc/key') }
        it { is_expected.to contain_sahara_config('oslo_messaging_rabbit/kombu_ssl_version').with_value('TLSv1') }
      end

      context 'with rabbit ssl cert parameters' do
        before do
          params.merge!({
            :rabbit_password => 'pass',
            :rabbit_use_ssl  => 'true',
          })
        end

        it { is_expected.to contain_sahara_config('oslo_messaging_rabbit/rabbit_use_ssl').with_value('true') }
        it { is_expected.to contain_sahara_config('oslo_messaging_rabbit/kombu_ssl_version').with_value('TLSv1') }
      end

      context 'with rabbit ssl disabled' do
        before do
          params.merge!({
            :rabbit_password    => 'pass',
            :rabbit_use_ssl     => false,
            :kombu_ssl_ca_certs => 'undef',
            :kombu_ssl_certfile => 'undef',
            :kombu_ssl_keyfile  => 'undef'
          })
        end

        it { is_expected.to contain_sahara_config('oslo_messaging_rabbit/rabbit_use_ssl').with_value('false') }
        it { is_expected.to contain_sahara_config('oslo_messaging_rabbit/kombu_ssl_ca_certs').with_ensure('absent') }
        it { is_expected.to contain_sahara_config('oslo_messaging_rabbit/kombu_ssl_certfile').with_ensure('absent') }
        it { is_expected.to contain_sahara_config('oslo_messaging_rabbit/kombu_ssl_keyfile').with_ensure('absent') }
        it { is_expected.to contain_sahara_config('oslo_messaging_rabbit/kombu_ssl_version').with_ensure('absent') }
      end

      context 'when passing params for single rabbit host' do
        before do
          params.merge!({
            :rabbit_password  => 'pass',
            :rabbit_userid    => 'guest2',
            :rabbit_host      => 'localhost2',
            :rabbit_port      => '5673',
            :rabbit_ha_queues => true,
          })
        end

        it { is_expected.to contain_sahara_config('oslo_messaging_rabbit/rabbit_userid').with_value('guest2') }
        it { is_expected.to contain_sahara_config('oslo_messaging_rabbit/rabbit_host').with_value('localhost2') }
        it { is_expected.to contain_sahara_config('oslo_messaging_rabbit/rabbit_port').with_value('5673') }
        it { is_expected.to contain_sahara_config('oslo_messaging_rabbit/rabbit_hosts').with_value('localhost2:5673') }
        it { is_expected.to contain_sahara_config('oslo_messaging_rabbit/rabbit_ha_queues').with_value('true') }
      end

      context 'when passing params for multiple rabbit hosts' do
        before do
          params.merge!({
            :rabbit_password => 'pass',
            :rabbit_userid   => 'guest3',
            :rabbit_hosts    => ['nonlocalhost3:5673', 'nonlocalhost4:5673']
          })
        end

        it { is_expected.to contain_sahara_config('oslo_messaging_rabbit/rabbit_userid').with_value('guest3') }
        it { is_expected.to contain_sahara_config('oslo_messaging_rabbit/rabbit_hosts').with_value('nonlocalhost3:5673,nonlocalhost4:5673') }
        it { is_expected.to contain_sahara_config('oslo_messaging_rabbit/rabbit_ha_queues').with_value('true') }
        it { is_expected.to_not contain_sahara_config('oslo_messaging_rabbit/rabbit_port') }
        it { is_expected.to_not contain_sahara_config('oslo_messaging_rabbit/rabbit_host') }
      end
    end

    context 'with qpid rpc' do
      before do
        params.merge!({ :rpc_backend => 'qpid' })
      end

      it { is_expected.to contain_sahara_config('DEFAULT/rpc_backend').with_value('qpid') }

      context 'when default params' do
        it { is_expected.to contain_sahara_config('oslo_messaging_qpid/qpid_username').with_value('guest') }
        it { is_expected.to contain_sahara_config('oslo_messaging_qpid/qpid_password').with_value('guest').with_secret(true) }
        it { is_expected.to contain_sahara_config('oslo_messaging_qpid/qpid_hostname').with_value('localhost') }
        it { is_expected.to contain_sahara_config('oslo_messaging_qpid/qpid_port').with_value('5672') }
        it { is_expected.to contain_sahara_config('oslo_messaging_qpid/qpid_hosts').with_value('localhost:5672') }
        it { is_expected.to contain_sahara_config('oslo_messaging_qpid/qpid_protocol').with_value('tcp') }
        it { is_expected.to contain_sahara_config('oslo_messaging_qpid/amqp_durable_queues').with_value('false') }
      end

      context 'when passing params' do
        before do
          params.merge!({
            :qpid_password       => 'pass',
            :qpid_username       => 'guest2',
            :qpid_hostname       => 'localhost2',
            :qpid_port           => '5673',
            :rpc_backend         => 'qpid',
            :amqp_durable_queues => 'true',
          })
        end

        it { is_expected.to contain_sahara_config('oslo_messaging_qpid/qpid_username').with_value('guest2') }
        it { is_expected.to contain_sahara_config('oslo_messaging_qpid/qpid_password').with_value('pass').with_secret(true) }
        it { is_expected.to contain_sahara_config('oslo_messaging_qpid/qpid_hostname').with_value('localhost2') }
        it { is_expected.to contain_sahara_config('oslo_messaging_qpid/qpid_port').with_value('5673') }
        it { is_expected.to contain_sahara_config('oslo_messaging_qpid/amqp_durable_queues').with_value('true') }
      end

      context 'when passing params for multiple qpid hosts' do
        before do
          params.merge!({
            :qpid_hosts  => ['nonlocalhost3:5673', 'nonlocalhost4:5673'],
            :rpc_backend  => 'qpid',
          })
        end

        it { is_expected.to contain_sahara_config('oslo_messaging_qpid/qpid_hosts').with_value('nonlocalhost3:5673,nonlocalhost4:5673') }
        it { is_expected.to_not contain_sahara_config('oslo_messaging_qpid/qpid_port') }
        it { is_expected.to_not contain_sahara_config('oslo_messaging_qpid/qpid_hostname') }
      end
    end

    context 'with zmq rpc' do
      before do
        params.merge!({ :rpc_backend => 'zmq' })
      end

      it { is_expected.to contain_sahara_config('DEFAULT/rpc_backend').with_value('zmq') }

      context 'with default params' do
        it { is_expected.to contain_sahara_config('DEFAULT/rpc_zmq_bind_address').with_value('*') }
        it { is_expected.to contain_sahara_config('DEFAULT/rpc_zmq_port').with_value('9501') }
        it { is_expected.to contain_sahara_config('DEFAULT/rpc_zmq_contexts').with_value('1') }
        it { is_expected.to contain_sahara_config('DEFAULT/rpc_zmq_topic_backlog').with_value('None') }
        it { is_expected.to contain_sahara_config('DEFAULT/rpc_zmq_ipc_dir').with_value('/var/run/openstack') }
        it { is_expected.to contain_sahara_config('DEFAULT/rpc_zmq_host').with_value('sahara') }
        it { is_expected.to contain_sahara_config('DEFAULT/rpc_cast_timeout').with_value('30') }
      end

      context 'when passing params' do
        before do
          params.merge!({
            :zeromq_bind_address => '*',
            :zeromq_port         => '9501',
            :zeromq_host         => 'localhost',
            :cast_timeout        => '30',
            :rpc_backend         => 'zmq',
          })
        end

        it { is_expected.to contain_sahara_config('DEFAULT/rpc_zmq_bind_address').with_value('*') }
        it { is_expected.to contain_sahara_config('DEFAULT/rpc_zmq_port').with_value('9501') }
        it { is_expected.to contain_sahara_config('DEFAULT/rpc_zmq_host').with_value('localhost') }
        it { is_expected.to contain_sahara_config('DEFAULT/rpc_cast_timeout').with_value('30') }
      end
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

  shared_examples_for 'with deprecated service' do |service|
    context 'with overridden parameters' do
      let :params do
        { :enabled        => true,
          :manage_service => true }
      end

      it 'installs package and service' do
        is_expected.to contain_class('sahara::service::all')
        is_expected.to contain_package('sahara-all').with({
          :name   => "#{service[:package_name]}",
          :notify => ['Service[sahara-all]', 'Exec[sahara-dbmanage]']
        })
        is_expected.to contain_service('sahara-all').with({
          :name      => "#{service[:service_name]}",
          :ensure    => 'running',
          :hasstatus => true,
          :enable    => true
        })
      end
    end

    context 'with default parameters' do
      it 'does not control service state' do
        is_expected.to_not contain_service('sahara-all')
        is_expected.to_not contain_package('sahara-all')
      end
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
    it_configures 'sahara rpc_backend'

    it_behaves_like 'with deprecated service', {
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
    it_configures 'sahara rpc_backend'

    it_behaves_like 'with deprecated service', {
       :package_name => 'openstack-sahara',
       :service_name => 'openstack-sahara-all' }
  end
end
