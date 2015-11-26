# == Class: sahara::notify::rabbitmq
#
#  RabbitMQ broker configuration for Sahara
#  Deprecated class
#
# === Parameters
#
# [*durable_queues*]
#   (Optional) Use durable queues in broker.
#   Defaults to $::os_service_default.
#
# [*rabbit_host*]
#   (Optional) IP or hostname of the rabbit server.
#   Defaults to $::os_service_default.
#
# [*rabbit_port*]
#   (Optional) Port of the rabbit server.
#   Defaults to $::os_service_default.
#
# [*rabbit_hosts*]
#   (Optional) IP or hostname of the rabbits servers.
#   comma separated array (ex: ['1.0.0.10:5672','1.0.0.11:5672'])
#   Defaults to $::os_service_default.
#
# [*rabbit_use_ssl*]
#   (Optional) Connect over SSL for RabbitMQ.
#   Defaults to $::os_service_default.
#
# [*rabbit_userid*]
#   (Optional) User to connect to the rabbit server.
#   Defaults to $::os_service_default.
#
# [*rabbit_password*]
#   (Optional) Password to connect to the rabbit server.
#   Defaults to $::os_service_default.
#
# [*rabbit_login_method*]
#   (Optional) Method to auth with the rabbit server.
#   Defaults to $::os_service_default.
#
# [*rabbit_virtual_host*]
#   (Optional) Virtual host to use.
#   Defaults to $::os_service_default.
#
# [*rabbit_retry_interval*]
#   (Optional) Reconnection attempt frequency for rabbit.
#   Defaults to $::os_service_default.
#
# [*rabbit_retry_backoff*]
#   (Optional) Backoff between reconnection attempts for rabbit.
#   Defaults to $::os_service_default.
#
# [*rabbit_max_retries*]
#   (Optional) Number of times to retry (0 == no limit).
#   Defaults to $::os_service_default.
#
# [*notification_topics*]
#   (Optional) Topic to use for notifications.
#   Defaults to $::os_service_default.
#
# [*control_exchange*]
#   (Optional) The default exchange to scope topics.
#   Defaults to $::os_service_default.
#
#  [*kombu_ssl_version*]
#    (optional) SSL version to use (valid only if SSL enabled).
#    Valid values are TLSv1, SSLv23 and SSLv3. SSLv2 may be
#    available on some distributions.
#    Defaults to $::os_service_default
#
# [*kombu_ssl_keyfile*]
#   (Optional) SSL key file (valid only if SSL enabled).
#   Defaults to $::os_service_default
#
# [*kombu_ssl_certfile*]
#   (Optional) SSL cert file (valid only if SSL enabled).
#   Defaults to $::os_service_default
#
# [*kombu_ssl_ca_certs*]
#   (Optional) SSL certification authority file (valid only if SSL enabled).
#   Defaults to $::os_service_default
#
# [*kombu_reconnect_delay*]
#   (Optional) Backoff on cancel notification (valid only if SSL enabled).
#   Defaults to '$::os_service_default; floating-point value.
#
class sahara::notify::rabbitmq(
  $durable_queues        = $::os_service_default,
  $rabbit_host           = $::os_service_default,
  $rabbit_hosts          = $::os_service_default,
  $rabbit_port           = $::os_service_default,
  $rabbit_use_ssl        = $::os_service_default,
  $rabbit_userid         = $::os_service_default,
  $rabbit_password       = $::os_service_default,
  $rabbit_login_method   = $::os_service_default,
  $rabbit_virtual_host   = $::os_service_default,
  $rabbit_retry_interval = $::os_service_default,
  $rabbit_retry_backoff  = $::os_service_default,
  $rabbit_max_retries    = $::os_service_default,
  $notification_topics   = $::os_service_default,
  $control_exchange      = $::os_service_default,
  $kombu_ssl_version     = $::os_service_default,
  $kombu_ssl_keyfile     = $::os_service_default,
  $kombu_ssl_certfile    = $::os_service_default,
  $kombu_ssl_ca_certs    = $::os_service_default,
  $kombu_reconnect_delay = $::os_service_default,
) {

  warning('This class is deprecated. Use sahara::init for configuration rpc options instead')
  warning('This class is deprecated. Use sahara::notify for configuration ceilometer notifications instead')

  if ! is_service_default($rabbit_hosts) and $rabbit_hosts {
    sahara_config {
      'oslo_messaging_rabbit/rabbit_hosts':     value => join($rabbit_hosts, ',');
      'oslo_messaging_rabbit/rabbit_ha_queues': value => true;
    }
  } else {
    sahara_config {
      'oslo_messaging_rabbit/rabbit_host':      value => $rabbit_host;
      'oslo_messaging_rabbit/rabbit_port':      value => $rabbit_port;
      'oslo_messaging_rabbit/rabbit_ha_queues': value => false;
      'oslo_messaging_rabbit/rabbit_hosts':     ensure => absent;
    }
  }

  sahara_config {
    'DEFAULT/rpc_backend':                         value => 'rabbit';
    'oslo_messaging_rabbit/amqp_durable_queues':   value => $durable_queues;
    'oslo_messaging_rabbit/rabbit_use_ssl':        value => $rabbit_use_ssl;
    'oslo_messaging_rabbit/rabbit_userid':         value => $rabbit_userid;
    'oslo_messaging_rabbit/rabbit_password':
      value => $rabbit_password,
      secret => true;
    'oslo_messaging_rabbit/rabbit_login_method':   value => $rabbit_login_method;
    'oslo_messaging_rabbit/rabbit_virtual_host':   value => $rabbit_virtual_host;
    'oslo_messaging_rabbit/rabbit_retry_interval': value => $rabbit_retry_interval;
    'oslo_messaging_rabbit/rabbit_retry_backoff':  value => $rabbit_retry_backoff;
    'oslo_messaging_rabbit/rabbit_max_retries':    value => $rabbit_max_retries;
    'DEFAULT/notification_topics':                 value => $notification_topics;
    'DEFAULT/control_exchange':                    value => $control_exchange;
    'oslo_messaging_rabbit/kombu_ssl_ca_certs':    value => $kombu_ssl_ca_certs;
    'oslo_messaging_rabbit/kombu_ssl_certfile':    value => $kombu_ssl_certfile;
    'oslo_messaging_rabbit/kombu_ssl_keyfile':     value => $kombu_ssl_keyfile;
    'oslo_messaging_rabbit/kombu_ssl_version':     value => $kombu_ssl_version;
    'oslo_messaging_rabbit/kombu_reconnect_delay': value => $kombu_reconnect_delay;
  }
}
