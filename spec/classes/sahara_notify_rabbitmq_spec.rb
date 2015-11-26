require 'spec_helper'
describe 'sahara::notify::rabbitmq' do
  let :facts do
    @default_facts.merge({
      :osfamily => 'Debian'
    })
  end

  describe 'when defaults with rabbit pass specified' do
    it { is_expected.to contain_sahara_config('oslo_messaging_rabbit/rabbit_password').with_value('<SERVICE DEFAULT>') }
    it { is_expected.to contain_sahara_config('oslo_messaging_rabbit/rabbit_userid').with_value('<SERVICE DEFAULT>') }
    it { is_expected.to contain_sahara_config('oslo_messaging_rabbit/rabbit_host').with_value('<SERVICE DEFAULT>') }
    it { is_expected.to contain_sahara_config('oslo_messaging_rabbit/rabbit_port').with_value('<SERVICE DEFAULT>') }
    it { is_expected.to contain_sahara_config('oslo_messaging_rabbit/rabbit_ha_queues').with_value('false') }
    it { is_expected.to contain_sahara_config('oslo_messaging_rabbit/amqp_durable_queues').with_value('<SERVICE DEFAULT>') }
    it { is_expected.to contain_sahara_config('oslo_messaging_rabbit/rabbit_virtual_host').with_value('<SERVICE DEFAULT>') }
    it { is_expected.to contain_sahara_config('oslo_messaging_rabbit/rabbit_hosts').with_ensure('absent') }
    it { is_expected.to contain_sahara_config('DEFAULT/control_exchange').with_value('<SERVICE DEFAULT>') }
    it { is_expected.to contain_sahara_config('DEFAULT/notification_topics').with_value('<SERVICE DEFAULT>') }
  end

  describe 'when passing params' do
    let :params do
      {
        :rabbit_password        => 'pass',
        :rabbit_userid          => 'guest2',
        :rabbit_host            => 'localhost2',
        :rabbit_port            => '5673',
        :durable_queues  => true,
      }
      it { is_expected.to contain_sahara_config('oslo_messaging_rabbit/rabbit_userid').with_value('guest2') }
      it { is_expected.to contain_sahara_config('oslo_messaging_rabbit/rabbit_host').with_value('localhost2') }
      it { is_expected.to contain_sahara_config('oslo_messaging_rabbit/rabbit_port').with_value('5673') }
      it { is_expected.to contain_sahara_config('oslo_messaging_rabbit/rabbit_durable_queues').with_value('true') }
      it { is_expected.to contain_sahara_config('oslo_messaging_rabbit/rabbit_hosts').with_ensure('absent') }
    end
  end

  describe 'with rabbit ssl cert parameters' do
    let :params do
      {
        :rabbit_password    => 'pass',
        :rabbit_use_ssl     => 'true',
        :kombu_ssl_ca_certs => '/etc/ca.cert',
        :kombu_ssl_certfile => '/etc/certfile',
        :kombu_ssl_keyfile  => '/etc/key',
        :kombu_ssl_version  => 'TLSv1',
      }
    end

    it { is_expected.to contain_sahara_config('oslo_messaging_rabbit/rabbit_use_ssl').with_value('true') }
    it { is_expected.to contain_sahara_config('oslo_messaging_rabbit/kombu_ssl_ca_certs').with_value('/etc/ca.cert') }
    it { is_expected.to contain_sahara_config('oslo_messaging_rabbit/kombu_ssl_certfile').with_value('/etc/certfile') }
    it { is_expected.to contain_sahara_config('oslo_messaging_rabbit/kombu_ssl_keyfile').with_value('/etc/key') }
    it { is_expected.to contain_sahara_config('oslo_messaging_rabbit/kombu_ssl_version').with_value('TLSv1') }
  end

  describe 'with rabbit ssl disabled' do
    let :params do
      {
        :rabbit_password    => 'pass',
        :rabbit_use_ssl     => false,
      }
    end

    it { is_expected.to contain_sahara_config('oslo_messaging_rabbit/rabbit_use_ssl').with_value('false') }
    it { is_expected.to contain_sahara_config('oslo_messaging_rabbit/kombu_ssl_ca_certs').with_value('<SERVICE DEFAULT>') }
    it { is_expected.to contain_sahara_config('oslo_messaging_rabbit/kombu_ssl_certfile').with_value('<SERVICE DEFAULT>') }
    it { is_expected.to contain_sahara_config('oslo_messaging_rabbit/kombu_ssl_keyfile').with_value('<SERVICE DEFAULT>') }
    it { is_expected.to contain_sahara_config('oslo_messaging_rabbit/kombu_ssl_version').with_value('<SERVICE DEFAULT>') }
  end

  describe 'when passing params for single rabbit host' do
    let :params do
      {
        :rabbit_password        => 'pass',
        :rabbit_userid          => 'guest2',
        :rabbit_host            => 'localhost2',
        :rabbit_port            => '5673',
        :durable_queues  => true,
      }
    end
    it { is_expected.to contain_sahara_config('oslo_messaging_rabbit/rabbit_userid').with_value('guest2') }
    it { is_expected.to contain_sahara_config('oslo_messaging_rabbit/rabbit_host').with_value('localhost2') }
    it { is_expected.to contain_sahara_config('oslo_messaging_rabbit/rabbit_port').with_value('5673') }
    it { is_expected.to contain_sahara_config('oslo_messaging_rabbit/amqp_durable_queues').with_value('true') }
    it { is_expected.to contain_sahara_config('oslo_messaging_rabbit/rabbit_hosts').with_ensure('absent') }
  end

  describe 'when passing params for multiple rabbit hosts' do
    let :params do
      {
        :rabbit_password        => 'pass',
        :rabbit_userid          => 'guest3',
        :rabbit_hosts           => ['nonlocalhost3:5673', 'nonlocalhost4:5673']
      }
    end
    it { is_expected.to contain_sahara_config('oslo_messaging_rabbit/rabbit_userid').with_value('guest3') }
    it { is_expected.to contain_sahara_config('oslo_messaging_rabbit/rabbit_hosts').with_value(
                                          'nonlocalhost3:5673,nonlocalhost4:5673') }
    it { is_expected.to contain_sahara_config('oslo_messaging_rabbit/rabbit_ha_queues').with_value('true') }
    it { is_expected.to_not contain_sahara_config('oslo_messaging_rabbit/rabbit_port') }
    it { is_expected.to_not contain_sahara_config('oslo_messaging_rabbit/rabbit_host') }
  end

end
