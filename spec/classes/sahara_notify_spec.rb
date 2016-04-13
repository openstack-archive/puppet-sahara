require 'spec_helper'
describe 'sahara::notify' do
  let :facts do
    @default_facts.merge({
      :osfamily => 'Debian'
    })
  end

  describe 'when defaults with notify enabled' do
    it { is_expected.to contain_sahara_config('DEFAULT/control_exchange').with_value('<SERVICE DEFAULT>') }
    it { is_expected.to contain_sahara_config('oslo_messaging_notifications/enable').with_value('<SERVICE DEFAULT>') }
    it { is_expected.to contain_sahara_config('oslo_messaging_notifications/driver').with_value('<SERVICE DEFAULT>') }
    it { is_expected.to contain_sahara_config('oslo_messaging_notifications/topics').with_value('<SERVICE DEFAULT>') }
    it { is_expected.to contain_sahara_config('oslo_messaging_notifications/level').with_value('<SERVICE DEFAULT>') }
  end

  describe 'when passing params' do
    let :params do
      {
        :enable_notifications => 'true',
        :control_exchange     => 'openstack',
        :notification_driver  => 'messaging',
        :notification_topics  => 'notifications',
        :notification_level   => 'INFO',
      }
    it { is_expected.to contain_sahara_config('DEFAULT/control_exchange').with_value('openstack') }
    it { is_expected.to contain_sahara_config('oslo_messaging_notifications/driver').with_value('messaging') }
    it { is_expected.to contain_sahara_config('oslo_messaging_notifications/enable').with_value('true') }
    it { is_expected.to contain_sahara_config('oslo_messaging_notifications/topics').with_value('notifications') }
    it { is_expected.to contain_sahara_config('oslo_messaging_notifications/level').with_value('INFO') }
    end
  end

end
