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
    it { is_expected.to contain_class('sahara::logging') }
    it { is_expected.to contain_class('sahara::policy') }
    it { is_expected.to contain_class('mysql::bindings::python') }
    it { is_expected.to contain_exec('sahara-dbmanage') }
  end

  shared_examples_for 'sahara config' do
    context 'with default params' do
      it { is_expected.to contain_sahara_config('DEFAULT/use_neutron').with_value('<SERVICE DEFAULT>') }
      it { is_expected.to contain_sahara_config('DEFAULT/use_floating_ips').with_value('<SERVICE DEFAULT>') }
      it { is_expected.to contain_sahara_config('DEFAULT/host').with_value('<SERVICE DEFAULT>') }
      it { is_expected.to contain_sahara_config('DEFAULT/port').with_value('<SERVICE DEFAULT>') }
      it { is_expected.to contain_sahara_config('keystone_authtoken/auth_uri').with_value('http://127.0.0.1:5000/v2.0/') }
      it { is_expected.to contain_sahara_config('keystone_authtoken/identity_uri').with_value('http://127.0.0.1:35357/') }
      it { is_expected.to contain_sahara_config('keystone_authtoken/admin_user').with_value('sahara') }
      it { is_expected.to contain_sahara_config('keystone_authtoken/admin_tenant_name').with_value('services') }
      it { is_expected.to contain_sahara_config('keystone_authtoken/admin_password').with_value('secrete').with_secret(true) }
      it { is_expected.to contain_sahara_config('DEFAULT/plugins').with_value('<SERVICE DEFAULT>') }
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

  end

  shared_examples_for 'sahara rpc_backend' do
    context 'with rabbit rpc' do
      before do
        params.merge!({ :rpc_backend => 'rabbit' })
      end
      it { is_expected.to contain_sahara_config('DEFAULT/rpc_backend').with_value('rabbit') }

      context 'when defaults with rabbit pass specified' do
         it { is_expected.to contain_sahara_config('oslo_messaging_rabbit/rabbit_password').with_value('<SERVICE DEFAULT>').with_secret(true) }
         it { is_expected.to contain_sahara_config('oslo_messaging_rabbit/rabbit_userid').with_value('<SERVICE DEFAULT>') }
         it { is_expected.to contain_sahara_config('oslo_messaging_rabbit/rabbit_host').with_value('<SERVICE DEFAULT>') }
         it { is_expected.to contain_sahara_config('oslo_messaging_rabbit/rabbit_port').with_value('<SERVICE DEFAULT>') }
         it { is_expected.to contain_sahara_config('oslo_messaging_rabbit/rabbit_ha_queues').with_value('<SERVICE DEFAULT>') }
         it { is_expected.to contain_sahara_config('oslo_messaging_rabbit/rabbit_virtual_host').with_value('<SERVICE DEFAULT>') }
         it { is_expected.to contain_sahara_config('oslo_messaging_rabbit/amqp_durable_queues').with_value('<SERVICE DEFAULT>') }
         it { is_expected.to contain_sahara_config('oslo_messaging_rabbit/rabbit_hosts').with_ensure('absent') }
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
        it { is_expected.to contain_sahara_config('oslo_messaging_rabbit/rabbit_hosts').with_ensure('absent') }
      end

      context 'with rabbit ssl cert parameters' do
        before do
          params.merge!({
            :rabbit_password    => 'pass',
            :rabbit_use_ssl     => 'true',
            :kombu_ssl_ca_certs => '/etc/ca.cert',
            :kombu_ssl_certfile => '/etc/certfile',
            :kombu_ssl_keyfile  => '/etc/key',
            :kombu_ssl_version  => 'TLSv1',
          })
        end

        it { is_expected.to contain_sahara_config('oslo_messaging_rabbit/rabbit_use_ssl').with_value('true') }
        it { is_expected.to contain_sahara_config('oslo_messaging_rabbit/kombu_ssl_ca_certs').with_value('/etc/ca.cert') }
        it { is_expected.to contain_sahara_config('oslo_messaging_rabbit/kombu_ssl_certfile').with_value('/etc/certfile') }
        it { is_expected.to contain_sahara_config('oslo_messaging_rabbit/kombu_ssl_keyfile').with_value('/etc/key') }
        it { is_expected.to contain_sahara_config('oslo_messaging_rabbit/kombu_ssl_version').with_value('TLSv1') }
      end

      context 'with rabbit ssl disabled' do
        before do
          params.merge!({
            :rabbit_password    => 'pass',
            :rabbit_use_ssl     => false,
          })
        end

        it { is_expected.to contain_sahara_config('oslo_messaging_rabbit/rabbit_use_ssl').with_value('false') }
        it { is_expected.to contain_sahara_config('oslo_messaging_rabbit/kombu_ssl_ca_certs').with_value('<SERVICE DEFAULT>') }
        it { is_expected.to contain_sahara_config('oslo_messaging_rabbit/kombu_ssl_certfile').with_value('<SERVICE DEFAULT>') }
        it { is_expected.to contain_sahara_config('oslo_messaging_rabbit/kombu_ssl_keyfile').with_value('<SERVICE DEFAULT>') }
        it { is_expected.to contain_sahara_config('oslo_messaging_rabbit/kombu_ssl_version').with_value('<SERVICE DEFAULT>') }
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
        it { is_expected.to contain_sahara_config('oslo_messaging_rabbit/rabbit_ha_queues').with_value('true') }
        it { is_expected.to contain_sahara_config('oslo_messaging_rabbit/rabbit_hosts').with_ensure('absent') }
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

    context 'with zmq rpc' do
      before do
        params.merge!({ :rpc_backend => 'zmq' })
      end

      it { is_expected.to contain_sahara_config('DEFAULT/rpc_backend').with_value('zmq') }

      context 'with default params' do
        it { is_expected.to contain_sahara_config('DEFAULT/rpc_zmq_bind_address').with_value('<SERVICE DEFAULT>') }
        it { is_expected.to contain_sahara_config('DEFAULT/rpc_zmq_contexts').with_value('<SERVICE DEFAULT>') }
        it { is_expected.to contain_sahara_config('DEFAULT/rpc_zmq_topic_backlog').with_value('<SERVICE DEFAULT>') }
        it { is_expected.to contain_sahara_config('DEFAULT/rpc_zmq_ipc_dir').with_value('<SERVICE DEFAULT>') }
        it { is_expected.to contain_sahara_config('DEFAULT/rpc_zmq_host').with_value('sahara') }
        it { is_expected.to contain_sahara_config('DEFAULT/rpc_cast_timeout').with_value('<SERVICE DEFAULT>') }
      end

      context 'when passing params' do
        before do
          params.merge!({
            :zeromq_bind_address => '*',
            :zeromq_host         => 'localhost',
            :cast_timeout        => '30',
            :rpc_backend         => 'zmq',
          })
        end

        it { is_expected.to contain_sahara_config('DEFAULT/rpc_zmq_bind_address').with_value('*') }
        it { is_expected.to contain_sahara_config('DEFAULT/rpc_zmq_host').with_value('localhost') }
        it { is_expected.to contain_sahara_config('DEFAULT/rpc_cast_timeout').with_value('30') }
      end
    end
  end

  shared_examples_for 'sahara ssl' do
    context 'without ssl' do
      it { is_expected.to_not contain_sahara_config('ssl/ca_file') }
      it { is_expected.to_not contain_sahara_config('ssl/cert_file') }
      it { is_expected.to_not contain_sahara_config('ssl/key_file') }
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
      @default_facts.merge({
        :osfamily => 'Debian',
        :operatingsystem => 'Debian'
      })
    end

    it_configures 'sahara'
    it_configures 'sahara config'
    it_configures 'sahara ssl'
    it_configures 'sahara rpc_backend'

  end

  context 'on RedHat platforms' do
    let :facts do
      @default_facts.merge({ :osfamily => 'RedHat' })
    end

    it_configures 'sahara'
    it_configures 'sahara config'
    it_configures 'sahara ssl'
    it_configures 'sahara rpc_backend'

  end
end
