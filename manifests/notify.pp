# == Class: sahara::notify
#
#  Ceilometer notifications configuration for Sahara
#
# === Parameters
#
# [*enable_notifications*]
#   (Optional) Enables sending notifications to Ceilometer.
#   Defaults to $::os_service_default.
#
# [*notification_transport_url*]
#   (optional) A URL representing the messaging driver to use for notifications
#   and its full configuration. Transport URLs take the form:
#     transport://user:pass@host1:port[,hostN:portN]/virtual_host
#   Defaults to $::os_service_default
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
# == DEPRECATED PARAMETERS
#
# [*control_exchange*]
#   (Optional) Moved to init.pp. The default exchange to scope topics.
#   Defaults to undef.
#

class sahara::notify (
  $enable_notifications       = $::os_service_default,
  $notification_transport_url = $::os_service_default,
  $notification_driver        = $::os_service_default,
  $notification_topics        = $::os_service_default,
  $notification_level         = $::os_service_default,
# DEPRECATED PARAMETERS
  $control_exchange           = undef,
) {

  if $control_exchange {
    warning('control_exchange is moved to ::sahara and will be removed from sahara::notify in a future release')
  }

  oslo::messaging::notifications { 'sahara_config':
    transport_url => $notification_transport_url,
    driver        => $notification_driver,
    topics        => $notification_topics,
  }

  sahara_config {
    'oslo_messaging_notifications/enable': value => $enable_notifications;
    'oslo_messaging_notifications/level':  value => $notification_level;
  }

}
