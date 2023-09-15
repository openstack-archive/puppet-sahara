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

  shared_examples 'sahara' do
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

  shared_examples 'sahara config' do
    context 'with default params' do
      it { is_expected.to contain_sahara_config('DEFAULT/use_floating_ips').with_value('<SERVICE DEFAULT>') }
      it { is_expected.to contain_sahara_config('DEFAULT/node_domain').with_value('<SERVICE DEFAULT>') }
      it { is_expected.to contain_sahara_config('DEFAULT/use_designate').with_value('<SERVICE DEFAULT>') }
      it { is_expected.to contain_sahara_config('DEFAULT/nameservers').with_value('<SERVICE DEFAULT>') }
      it { is_expected.to contain_sahara_config('DEFAULT/host').with_value('<SERVICE DEFAULT>') }
      it { is_expected.to contain_sahara_config('DEFAULT/port').with_value('<SERVICE DEFAULT>') }
      it { is_expected.to contain_sahara_config('DEFAULT/plugins').with_value('<SERVICE DEFAULT>') }

      it { is_expected.to contain_oslo__messaging__rabbit('sahara_config').with(
        :rabbit_use_ssl                  => '<SERVICE DEFAULT>',
        :heartbeat_timeout_threshold     => '<SERVICE DEFAULT>',
        :heartbeat_rate                  => '<SERVICE DEFAULT>',
        :heartbeat_in_pthread            => '<SERVICE DEFAULT>',
        :kombu_reconnect_delay           => '<SERVICE DEFAULT>',
        :kombu_failover_strategy         => '<SERVICE DEFAULT>',
        :amqp_durable_queues             => '<SERVICE DEFAULT>',
        :kombu_compression               => '<SERVICE DEFAULT>',
        :kombu_ssl_ca_certs              => '<SERVICE DEFAULT>',
        :kombu_ssl_certfile              => '<SERVICE DEFAULT>',
        :kombu_ssl_keyfile               => '<SERVICE DEFAULT>',
        :kombu_ssl_version               => '<SERVICE DEFAULT>',
        :rabbit_ha_queues                => '<SERVICE DEFAULT>',
        :rabbit_retry_interval           => '<SERVICE DEFAULT>',
        :rabbit_quorum_queue             => '<SERVICE DEFAULT>',
        :rabbit_quorum_delivery_limit    => '<SERVICE DEFAULT>',
        :rabbit_quorum_max_memory_length => '<SERVICE DEFAULT>',
        :rabbit_quorum_max_memory_bytes  => '<SERVICE DEFAULT>',
      ) }
      it { is_expected.to contain_oslo__messaging__default('sahara_config').with(
        :transport_url        => '<SERVICE DEFAULT>',
        :rpc_response_timeout => '<SERVICE DEFAULT>',
        :control_exchange     => '<SERVICE DEFAULT>'
      ) }
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

  shared_examples 'sahara rpc' do
    context 'when passing params' do
      before do
        params.merge!({
          :rabbit_ha_queues                => true,
          :amqp_durable_queues             => true,
          :rabbit_heartbeat_in_pthread     => true,
          :kombu_reconnect_delay           => '1.0',
          :kombu_compression               => 'gzip',
          :kombu_failover_strategy         => 'round-robin',
          :rabbit_quorum_queue             => true,
          :rabbit_quorum_delivery_limit    => 3,
          :rabbit_quorum_max_memory_length => 5,
          :rabbit_quorum_max_memory_bytes  => 1073741824,
        })
      end

      it { is_expected.to contain_oslo__messaging__rabbit('sahara_config').with(
        :rabbit_use_ssl                  => '<SERVICE DEFAULT>',
        :heartbeat_timeout_threshold     => '<SERVICE DEFAULT>',
        :heartbeat_rate                  => '<SERVICE DEFAULT>',
        :heartbeat_in_pthread            => true,
        :kombu_reconnect_delay           => '1.0',
        :kombu_failover_strategy         => 'round-robin',
        :amqp_durable_queues             => true,
        :kombu_compression               => 'gzip',
        :rabbit_quorum_queue             => true,
        :rabbit_quorum_delivery_limit    => 3,
        :rabbit_quorum_max_memory_length => 5,
        :rabbit_quorum_max_memory_bytes  => 1073741824,
      ) }
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
          :rabbit_use_ssl => false,
        })
      end

      it { is_expected.to contain_oslo__messaging__rabbit('sahara_config').with(
        :rabbit_use_ssl => false,
      )}
    end

    context 'with amqp rpc' do

      context 'with default parameters' do
        it { is_expected.to contain_oslo__messaging__amqp('sahara_config').with(
          :server_request_prefix => '<SERVICE DEFAULT>',
          :broadcast_prefix      => '<SERVICE DEFAULT>',
          :group_request_prefix  => '<SERVICE DEFAULT>',
          :container_name        => '<SERVICE DEFAULT>',
          :idle_timeout          => '<SERVICE DEFAULT>',
          :trace                 => '<SERVICE DEFAULT>',
          :ssl_ca_file           => '<SERVICE DEFAULT>',
          :ssl_cert_file         => '<SERVICE DEFAULT>',
          :ssl_key_file          => '<SERVICE DEFAULT>',
          :sasl_mechanisms       => '<SERVICE DEFAULT>',
          :sasl_config_dir       => '<SERVICE DEFAULT>',
          :sasl_config_name      => '<SERVICE DEFAULT>',
          :username              => '<SERVICE DEFAULT>',
          :password              => '<SERVICE DEFAULT>',
        )}
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

        it { is_expected.to contain_oslo__messaging__amqp('sahara_config').with(
          :idle_timeout          => '60',
          :trace                 => true,
          :ssl_ca_file           => '/etc/ca.cert',
          :ssl_cert_file         => '/etc/certfile',
          :ssl_key_file          => '/etc/key',
          :username              => 'amqp_user',
          :password              => 'password',
        )}
      end
    end
  end

  shared_examples 'sahara ssl' do
    context 'without ssl' do
      it { is_expected.to contain_sahara_config('ssl/ca_file').with_ensure('absent') }
      it { is_expected.to contain_sahara_config('ssl/cert_file').with_ensure('absent') }
      it { is_expected.to contain_sahara_config('ssl/key_file').with_ensure('absent') }
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
