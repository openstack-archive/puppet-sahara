# == Class: sahara::notify
#
#  Ceilometer notifications configuration for Sahara
#
# === Parameters
#
# [*control_exchange*]
#   (Optional) The default exchange to scope topics.
#   Defaults to $::os_service_default.
#
# [*enable_notifications*]
#   (Optional) Enables sending notifications to Ceilometer.
#   Defaults to $::os_service_default.
#
# [*notification_driver*]
#   (Optional) Notification driver to use.
#   Defaults to $::os_service_default.
#
# [*notification_topics*]
#   (Optional) Topic to use for notifications.
#   Defaults to $::os_service_default.
#
# [*notification_level*]
#   (Optional) Notification level for outgoing notifications.
#   Defaults to $::os_service_default.
#

class sahara::notify (
  $control_exchange     = $::os_service_default,
  $enable_notifications = $::os_service_default,
  $notification_driver  = $::os_service_default,
  $notification_topics  = $::os_service_default,
  $notification_level   = $::os_service_default,
) {

  oslo::messaging::notifications { 'sahara_config':
    driver => $notification_driver,
    topics => $notification_topics,
  }

  oslo::messaging::default { 'sahara_config':
    control_exchange => $control_exchange
  }

  sahara_config {
    'oslo_messaging_notifications/enable': value => $enable_notifications;
    'oslo_messaging_notifications/level':  value => $notification_level;
  }

}
