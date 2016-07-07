require 'spec_helper'
describe 'sahara::notify' do

  shared_examples_for 'sahara-notify' do
    context 'when defaults with notify enabled' do
      it { is_expected.to contain_sahara_config('oslo_messaging_notifications/transport_url').with_value('<SERVICE DEFAULT>') }
      it { is_expected.to contain_sahara_config('oslo_messaging_notifications/enable').with_value('<SERVICE DEFAULT>') }
      it { is_expected.to contain_sahara_config('oslo_messaging_notifications/driver').with_value('<SERVICE DEFAULT>') }
      it { is_expected.to contain_sahara_config('oslo_messaging_notifications/topics').with_value('<SERVICE DEFAULT>') }
      it { is_expected.to contain_sahara_config('oslo_messaging_notifications/level').with_value('<SERVICE DEFAULT>') }
    end

    context 'when passing params' do
      let :params do
        {
          :enable_notifications       => 'true',
          :notification_transport_url => 'rabbit://guest2:pass@localhost2:5673',
          :notification_driver        => 'messaging',
          :notification_topics        => 'notifications',
          :notification_level         => 'INFO',
        }
      it { is_expected.to contain_sahara_config('oslo_messaging_notifications/transport_url').with_value('rabbit://guest2:pass@localhost2:5673') }
      it { is_expected.to contain_sahara_config('oslo_messaging_notifications/driver').with_value('messaging') }
      it { is_expected.to contain_sahara_config('oslo_messaging_notifications/enable').with_value('true') }
      it { is_expected.to contain_sahara_config('oslo_messaging_notifications/topics').with_value('notifications') }
      it { is_expected.to contain_sahara_config('oslo_messaging_notifications/level').with_value('INFO') }
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

      it_configures 'sahara-notify'
    end
  end


end

