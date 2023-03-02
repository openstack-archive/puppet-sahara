# == Class: sahara::notify
#
#  Ceilometer notifications configuration for Sahara
#
# === Parameters
#
# [*notification_transport_url*]
#   (Optional) A URL representing the messaging driver to use for notifications
#   and its full configuration. Transport URLs take the form:
#     transport://user:pass@host1:port[,hostN:portN]/virtual_host
#   Defaults to $facts['os_service_default']
#
# [*notification_driver*]
#   (Optional) Notification driver to use.
#   Defaults to $facts['os_service_default'].
#
# [*notification_topics*]
#   (Optional) Topic to use for notifications.
#   Defaults to $facts['os_service_default'].
#
class sahara::notify (
  $notification_transport_url = $facts['os_service_default'],
  $notification_driver        = $facts['os_service_default'],
  $notification_topics        = $facts['os_service_default'],
) {

  include sahara::deps

  oslo::messaging::notifications { 'sahara_config':
    transport_url => $notification_transport_url,
    driver        => $notification_driver,
    topics        => $notification_topics,
  }

}
