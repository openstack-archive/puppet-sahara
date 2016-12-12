# == Class: sahara::notify
#
#  Ceilometer notifications configuration for Sahara
#
# === Parameters
#
# [*notification_transport_url*]
#   (optional) A URL representing the messaging driver to use for notifications
#   and its full configuration. Transport URLs take the form:
#     transport://user:pass@host1:port[,hostN:portN]/virtual_host
#   Defaults to $::os_service_default
#
# [*notification_driver*]
#   (Optional) Notification driver to use. WARNING: the enable_notifications is
#   deprecated. plese specify the notification_driver if you wish to enable 
#   notifications
#   Defaults to $::os_service_default.
#
# [*notification_topics*]
#   (Optional) Topic to use for notifications.
#   Defaults to $::os_service_default.
#
# == DEPRECATED PARAMETERS
#
# [*control_exchange*]
#   (Optional) Moved to init.pp. The default exchange to scope topics.
#   Defaults to undef.
#
# [*enable_notifications*]
#   (Optional) Enables sending notifications to Ceilometer.
#   Defaults to undef.
#
# [*notification_level*]
#   (Optional) Notification level for outgoing notifications.
#   Defaults to undef.
#

class sahara::notify (
  $notification_transport_url = $::os_service_default,
  $notification_driver        = $::os_service_default,
  $notification_topics        = $::os_service_default,
# DEPRECATED PARAMETERS
  $control_exchange           = undef,
  $enable_notifications       = undef,
  $notification_level         = undef,
) {

  include ::sahara::deps

  if $control_exchange {
    warning('control_exchange is moved to ::sahara and will be removed from sahara::notify in a future release')
  }
  if $enable_notifications {
    warning("The enable_notifications is deprecated and will be removed in a future release. plese specify \
the notification_driver if you wish to enable notifications")
  }
  if $notification_level {
    warning('notification_level is deprecated and will be removed in a future release')
  }
  oslo::messaging::notifications { 'sahara_config':
    transport_url => $notification_transport_url,
    driver        => $notification_driver,
    topics        => $notification_topics,
  }

  # TODO(xingzhou): these are deprecated, remove in P
  sahara_config {
    'oslo_messaging_notifications/enable': ensure => 'absent';
    'oslo_messaging_notifications/level':  ensure => 'absent';
  }

}
