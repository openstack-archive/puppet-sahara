# == Class: sahara::notify::qpid
#
#  Qpid broker configuration for Sahara
#
# === Parameters
#
# [*durable_queues*]
#   (Optional) Use durable queues in broker.
#   Defaults to false.
#
# [*qpid_hostname*]
#   (Optional) IP or hostname of the qpid server.
#   Defaults to '127.0.0.1'.
#
# [*qpid_port*]
#   (Optional) Port of the qpid server.
#   Defaults to 5672.
#
# [*qpid_username*]
#   (Optional) User to connect to the qpid server.
#   Defaults to 'guest'.
#
# [*qpid_password*]
#   (Optional) Password to connect to the qpid server.
#   Defaults to 'guest'.
#
# [*qpid_sasl_mechanisms*]
#   (Optional) String of SASL mechanisms to use.
#   Defaults to ''.
#
# [*qpid_heartbeat*]
#   (Optional) Seconds between connection keepalive heartbeats.
#   Defaults to 60.
#
# [*qpid_protocol*]
#   (Optional) Protocol to use for qpid (tcp/ssl).
#   Defaults to tcp.
#
# [*qpid_tcp_nodelay*]
#   (Optional) Whether to disable the Nagle algorithm.
#   Defaults to true.
#
# [*qpid_receiver_capacity*]
#   (Optional) Number of prefetched messages to hold.
#   Defaults to 1.
#
# [*qpid_topology_version*]
#   (Optional) Version of qpid toplogy to use.
#   Defaults to 2.
#
# [*notification_topics*]
#   (Optional) Topic to use for notifications.
#   Defaults to 'notifications'.
#
# [*control_exchange*]
#   (Optional) The default exchange to scope topics.
#   Defaults to 'openstack'.
#
# == DEPRECATED PARAMETERS
#
#  [*kombu_ssl_version*]
#    (optional) SSL version to use (valid only if SSL enabled).
#    Valid values are TLSv1, SSLv23 and SSLv3. SSLv2 may be
#    available on some distributions.
#    Defaults to undef
#
# [*kombu_ssl_keyfile*]
#   (Optional) SSL key file (valid only if SSL enabled).
#   Defaults to undef.
#
# [*kombu_ssl_certfile*]
#   (Optional) SSL cert file (valid only if SSL enabled).
#   Defaults to undef.
#
# [*kombu_ssl_ca_certs*]
#   (optional) SSL certification authority file (valid only if SSL enabled).
#   Defaults to undef.
#
# [*kombu_reconnect_delay*]
#   (Optional) Backoff on cancel notification (valid only if SSL enabled).
#   Defaults to undef
#
class sahara::notify::qpid(
  $durable_queues         = false,
  $qpid_hostname          = 'localhost',
  $qpid_port              = 5672,
  $qpid_username          = 'guest',
  $qpid_password          = 'guest',
  $qpid_sasl_mechanisms   = '',
  $qpid_heartbeat         = 60,
  $qpid_protocol          = 'tcp',
  $qpid_tcp_nodelay       = true,
  $qpid_receiver_capacity = 1,
  $qpid_topology_version  = 2,
  $notification_topics    = 'notifications',
  $control_exchange       = 'openstack',
  # DEPRECATED PARAMETERS
  $kombu_ssl_version      = undef,
  $kombu_ssl_keyfile      = undef,
  $kombu_ssl_certfile     = undef,
  $kombu_ssl_ca_certs     = undef,
  $kombu_reconnect_delay  = undef,
) {

  if $kombu_ssl_version {
    warning('The kombu_ssl_version parameter is deprecated and has no effect.')
  }

  if $kombu_ssl_keyfile {
    warning('The kombu_ssl_keyfile parameter is deprecated and has no effect.')
  }

  if $kombu_ssl_certfile {
    warning('The kombu_ssl_certfile is deprecated and has no effect.')
  }

  if $kombu_ssl_ca_certs {
    warning('The kombu_ssl_ca_certs is deprecated and has no effect.')
  }

  if $kombu_reconnect_delay {
    warning('The kombu_reconnect_delay is deprecated and has no effect.')
  }

  sahara_config {
    'DEFAULT/rpc_backend':                        value => 'qpid';
    'oslo_messaging_qpid/qpid_hosts':             value => '$qpid_hostname:$qpid_port';

    'oslo_messaging_qpid/amqp_durable_queues':    value => $durable_queues;
    'oslo_messaging_qpid/qpid_hostname':          value => $qpid_hostname;
    'oslo_messaging_qpid/qpid_port':              value => $qpid_port;
    'oslo_messaging_qpid/qpid_username':          value => $qpid_username;
    'oslo_messaging_qpid/qpid_password':
      value => $qpid_password,
      secret => true;
    'oslo_messaging_qpid/qpid_sasl_mechanisms':   value => $qpid_sasl_mechanisms;
    'oslo_messaging_qpid/qpid_heartbeat':         value => $qpid_heartbeat;
    'oslo_messaging_qpid/qpid_protocol':          value => $qpid_protocol;
    'oslo_messaging_qpid/qpid_tcp_nodelay':       value => $qpid_tcp_nodelay;
    'oslo_messaging_qpid/qpid_receiver_capacity': value => $qpid_receiver_capacity;
    'oslo_messaging_qpid/qpid_topology_version':  value => $qpid_topology_version;
    'DEFAULT/notification_topics':                value => $notification_topics;
    'DEFAULT/control_exchange':                   value => $control_exchange;
  }
}
