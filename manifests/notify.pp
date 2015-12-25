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

  sahara_config {
    'DEFAULT/control_exchange':     value => $control_exchange;
    'DEFAULT/enable_notifications': value => $enable_notifications;
    'DEFAULT/notification_driver':  value => $notification_driver;
    'DEFAULT/notification_topics':  value => $notification_topics;
    'DEFAULT/notification_level':   value => $notification_level;
  }

}
