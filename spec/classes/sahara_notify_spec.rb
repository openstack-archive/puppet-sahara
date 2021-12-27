require 'spec_helper'
describe 'sahara::notify' do

  shared_examples 'sahara-notify' do
    context 'when defaults parameters' do
      it { is_expected.to contain_sahara_config('oslo_messaging_notifications/transport_url').with_value('<SERVICE DEFAULT>') }
      it { is_expected.to contain_sahara_config('oslo_messaging_notifications/driver').with_value('<SERVICE DEFAULT>') }
      it { is_expected.to contain_sahara_config('oslo_messaging_notifications/topics').with_value('<SERVICE DEFAULT>') }
    end

    context 'with overridden parameters' do
      let :params do
        {
          :notification_transport_url => 'rabbit://guest2:pass@localhost2:5673',
          :notification_driver        => 'messaging',
          :notification_topics        => 'notifications',
        }
      it { is_expected.to contain_sahara_config('oslo_messaging_notifications/transport_url').with_value('rabbit://guest2:pass@localhost2:5673') }
      it { is_expected.to contain_sahara_config('oslo_messaging_notifications/driver').with_value('messaging') }
      it { is_expected.to contain_sahara_config('oslo_messaging_notifications/topics').with_value('notifications') }
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

