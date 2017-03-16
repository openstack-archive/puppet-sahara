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
class sahara::notify (
  $notification_transport_url = $::os_service_default,
  $notification_driver        = $::os_service_default,
  $notification_topics        = $::os_service_default,
) {

  include ::sahara::deps

  oslo::messaging::notifications { 'sahara_config':
    transport_url => $notification_transport_url,
    driver        => $notification_driver,
    topics        => $notification_topics,
  }

}
