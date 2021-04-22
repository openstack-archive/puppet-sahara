#
# Unit tests for sahara::init
#
require 'spec_helper'

describe 'sahara' do

  let :params do
    {
      :purge_config => false,
    }
  end

  shared_examples_for 'sahara' do
    it { is_expected.to contain_class('sahara::deps') }
    it { is_expected.to contain_class('sahara::params') }
    it { is_expected.to contain_class('sahara::db') }
    it { is_expected.to contain_class('mysql::bindings::python') }
    it { is_expected.to contain_exec('sahara-dbmanage') }

    it 'passes purge to resource' do
      is_expected.to contain_resources('sahara_config').with({
        :purge => false
      })
    end
  end

  shared_examples_for 'sahara config' do
    context 'with default params' do
      it { is_expected.to contain_sahara_config('DEFAULT/use_floating_ips').with_value('<SERVICE DEFAULT>') }
      it { is_expected.to contain_sahara_config('DEFAULT/host').with_value('<SERVICE DEFAULT>') }
      it { is_expected.to contain_sahara_config('DEFAULT/port').with_value('<SERVICE DEFAULT>') }
      it { is_expected.to contain_sahara_config('DEFAULT/plugins').with_value('<SERVICE DEFAULT>') }
      it { is_expected.to contain_sahara_config('oslo_messaging_rabbit/kombu_reconnect_delay').with_value('<SERVICE DEFAULT>') }
      it { is_expected.to contain_sahara_config('oslo_messaging_rabbit/kombu_compression').with_value('<SERVICE DEFAULT>') }
      it { is_expected.to contain_sahara_config('oslo_messaging_rabbit/kombu_failover_strategy').with_value('<SERVICE DEFAULT>') }
      it { is_expected.to contain_sahara_config('oslo_messaging_rabbit/heartbeat_in_pthread').with_value('<SERVICE DEFAULT>') }
      it { is_expected.to contain_sahara_config('DEFAULT/transport_url').with_value('<SERVICE DEFAULT>') }
      it { is_expected.to contain_sahara_config('DEFAULT/control_exchange').with_value('<SERVICE DEFAULT>') }
      it { is_expected.to contain_sahara_config('DEFAULT/rpc_response_timeout').with_value('<SERVICE DEFAULT>') }
      it { is_expected.to contain_sahara_config('DEFAULT/default_ntp_server').with_value('<SERVICE DEFAULT>') }
    end

    context 'with passing params' do
      let :params do {
        :host                  => 'localhost',
        :port                  => '8387',
        :plugins               => ['plugin1', 'plugin2'],
        :default_transport_url => 'rabbit://guest2:pass@localhost2:5673',
        :rpc_response_timeout  => '120',
        :control_exchange      => 'openstack',
        :default_ntp_server    => 'pool.ntp.org',
      }
      end

      it { is_expected.to contain_sahara_config('DEFAULT/host').with_value('localhost') }
      it { is_expected.to contain_sahara_config('DEFAULT/plugins').with_value('plugin1,plugin2') }
      it { is_expected.to contain_sahara_config('DEFAULT/transport_url').with_value('rabbit://guest2:pass@localhost2:5673') }
      it { is_expected.to contain_sahara_config('DEFAULT/rpc_response_timeout').with_value('120') }
      it { is_expected.to contain_sahara_config('DEFAULT/control_exchange').with_value('openstack') }
      it { is_expected.to contain_sahara_config('DEFAULT/default_ntp_server').with_value('pool.ntp.org') }
    end

  end

  shared_examples_for 'sahara rpc' do

    context 'when defaults with rabbit pass specified' do
       it { is_expected.to contain_sahara_config('oslo_messaging_rabbit/rabbit_ha_queues').with_value('<SERVICE DEFAULT>') }
       it { is_expected.to contain_sahara_config('oslo_messaging_rabbit/amqp_durable_queues').with_value('<SERVICE DEFAULT>') }
    end

    context 'when passing params' do
      before do
        params.merge!({
          :rabbit_ha_queues            => 'true',
          :amqp_durable_queues         => 'true',
          :rabbit_heartbeat_in_pthread => 'true',
          :kombu_reconnect_delay       => '1.0',
          :kombu_compression           => 'gzip',
          :kombu_failover_strategy     => 'round-robin',
        })
      end

      it { is_expected.to contain_sahara_config('oslo_messaging_rabbit/rabbit_ha_queues').with_value('true') }
      it { is_expected.to contain_sahara_config('oslo_messaging_rabbit/amqp_durable_queues').with_value('true') }
      it { is_expected.to contain_sahara_config('oslo_messaging_rabbit/heartbeat_in_pthread').with_value('true') }
      it { is_expected.to contain_sahara_config('oslo_messaging_rabbit/kombu_reconnect_delay').with_value('1.0') }
      it { is_expected.to contain_sahara_config('oslo_messaging_rabbit/kombu_compression').with_value('gzip') }
      it { is_expected.to contain_sahara_config('oslo_messaging_rabbit/kombu_failover_strategy').with_value('round-robin') }
    end

    context 'with rabbit ssl cert parameters' do
      before do
        params.merge!({
          :rabbit_use_ssl     => true,
          :kombu_ssl_ca_certs => '/etc/ca.cert',
          :kombu_ssl_certfile => '/etc/certfile',
          :kombu_ssl_keyfile  => '/etc/key',
          :kombu_ssl_version  => 'TLSv1',
        })
      end
      it { is_expected.to contain_oslo__messaging__rabbit('sahara_config').with(
        :rabbit_use_ssl     => true,
        :kombu_ssl_ca_certs => '/etc/ca.cert',
        :kombu_ssl_certfile => '/etc/certfile',
        :kombu_ssl_keyfile  => '/etc/key',
        :kombu_ssl_version  => 'TLSv1',
      )}
    end

    context 'with rabbit ssl disabled' do
      before do
        params.merge!({
          :rabbit_use_ssl     => false,
        })
      end

      it { is_expected.to contain_oslo__messaging__rabbit('sahara_config').with(
        :rabbit_use_ssl     => false,
      )}
    end

    context 'when passing params for single rabbit host' do
      before do
        params.merge!({
          :rabbit_ha_queues => true,
        })
      end

      it { is_expected.to contain_sahara_config('oslo_messaging_rabbit/rabbit_ha_queues').with_value('true') }
    end

    context 'with amqp rpc' do

      context 'with default parameters' do
        it { is_expected.to contain_sahara_config('oslo_messaging_amqp/server_request_prefix').with_value('<SERVICE DEFAULT>') }
        it { is_expected.to contain_sahara_config('oslo_messaging_amqp/broadcast_prefix').with_value('<SERVICE DEFAULT>') }
        it { is_expected.to contain_sahara_config('oslo_messaging_amqp/group_request_prefix').with_value('<SERVICE DEFAULT>') }
        it { is_expected.to contain_sahara_config('oslo_messaging_amqp/container_name').with_value('<SERVICE DEFAULT>') }
        it { is_expected.to contain_sahara_config('oslo_messaging_amqp/idle_timeout').with_value('<SERVICE DEFAULT>') }
        it { is_expected.to contain_sahara_config('oslo_messaging_amqp/trace').with_value('<SERVICE DEFAULT>') }
        it { is_expected.to contain_sahara_config('oslo_messaging_amqp/ssl_ca_file').with_value('<SERVICE DEFAULT>') }
        it { is_expected.to contain_sahara_config('oslo_messaging_amqp/ssl_cert_file').with_value('<SERVICE DEFAULT>') }
        it { is_expected.to contain_sahara_config('oslo_messaging_amqp/ssl_key_file').with_value('<SERVICE DEFAULT>') }
        it { is_expected.to contain_sahara_config('oslo_messaging_amqp/ssl_key_password').with_value('<SERVICE DEFAULT>') }
        it { is_expected.to contain_sahara_config('oslo_messaging_amqp/sasl_mechanisms').with_value('<SERVICE DEFAULT>') }
        it { is_expected.to contain_sahara_config('oslo_messaging_amqp/sasl_config_dir').with_value('<SERVICE DEFAULT>') }
        it { is_expected.to contain_sahara_config('oslo_messaging_amqp/sasl_config_name').with_value('<SERVICE DEFAULT>') }
        it { is_expected.to contain_sahara_config('oslo_messaging_amqp/username').with_value('<SERVICE DEFAULT>') }
        it { is_expected.to contain_sahara_config('oslo_messaging_amqp/password').with_value('<SERVICE DEFAULT>') }
      end

      context 'when pass parameters' do
        before do
          params.merge!({
            :amqp_idle_timeout  => '60',
            :amqp_trace         => true,
            :amqp_ssl_ca_file   => '/etc/ca.cert',
            :amqp_ssl_cert_file => '/etc/certfile',
            :amqp_ssl_key_file  => '/etc/key',
            :amqp_username      => 'amqp_user',
            :amqp_password      => 'password',
          })
        end

        it { is_expected.to contain_sahara_config('oslo_messaging_amqp/idle_timeout').with_value('60') }
        it { is_expected.to contain_sahara_config('oslo_messaging_amqp/trace').with_value('true') }
        it { is_expected.to contain_sahara_config('oslo_messaging_amqp/ssl_ca_file').with_value('/etc/ca.cert') }
        it { is_expected.to contain_sahara_config('oslo_messaging_amqp/ssl_cert_file').with_value('/etc/certfile') }
        it { is_expected.to contain_sahara_config('oslo_messaging_amqp/ssl_key_file').with_value('/etc/key') }
        it { is_expected.to contain_sahara_config('oslo_messaging_amqp/username').with_value('amqp_user') }
        it { is_expected.to contain_sahara_config('oslo_messaging_amqp/password').with_value('password') }
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
        :use_ssl   => true,
        :ca_file   => '/tmp/ca_file',
        :cert_file => '/tmp/cert_file',
        :key_file  => '/tmp/key_file',
      }
      end
      it { is_expected.to contain_sahara_config('ssl/ca_file').with_value('/tmp/ca_file') }
      it { is_expected.to contain_sahara_config('ssl/cert_file').with_value('/tmp/cert_file') }
      it { is_expected.to contain_sahara_config('ssl/key_file').with_value('/tmp/key_file') }
    end

    context 'with ssl but without cert_file' do
      let :params do
      {
        :use_ssl   => true,
      }
      end

      it { should raise_error(Puppet::Error, /The cert_file parameter is required when use_ssl is set to true/) }
    end

    context 'with ssl but without key_file' do
      let :params do
      {
        :use_ssl   => true,
        :cert_file => '/tmp/cert_file',
      }
      end

      it { should raise_error(Puppet::Error, /The key_file parameter is required when use_ssl is set to true/) }
    end
  end

  on_supported_os({
    :supported_os   => OSDefaults.get_supported_os
  }).each do |os,facts|
    context "on #{os}" do
      let (:facts) do
        facts.merge(OSDefaults.get_facts)
      end

      it_configures 'sahara'
      it_configures 'sahara config'
      it_configures 'sahara ssl'
      it_configures 'sahara rpc'
    end
  end

end
