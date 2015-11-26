# == Class: sahara::notify::zeromq
#
#  Zeromq broker configuration for Sahara
#  Deprecated class
#
# === Parameters
#
# [*zeromq_bind_address*]
#   (Optional) Bind address; wildcard, ethernet, or ip address.
#   Defaults to '*'.
#
# [*zeromq_contexts*]
#   (Optional) Number of contexsts for zeromq.
#   Defaults to 1.
#
# [*zeromq_topic_backlog*]
#   (Optional) Number of incoming messages to buffer.
#   Defaults to 'None'.
#
# [*zeromq_ipc_dir*]
#   (Optional) Directory for zeromq IPC.
#   Defaults to '/var/run/openstack'.
#
# [*zeromq_host*]
#   (Optional) Name of the current node: hostname, FQDN, or IP.
#   Defaults to 'sahara'.
#
# [*cast_timeout*]
#   (Optional) TTL for zeromq messages.
#   Defaults to 30.
#
# == DEPRECATED PARAMETERS
#
#  [*zeromq_port*]
#   (Optional) Receiver listening port.
#   Defaults to undef.
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
class sahara::notify::zeromq(
  $zeromq_bind_address    = $::os_service_default,
  $zeromq_contexts        = $::os_service_default,
  $zeromq_topic_backlog   = $::os_service_default,
  $zeromq_ipc_dir         = $::os_service_default,
  $zeromq_host            = 'sahara',
  $cast_timeout           = $::os_service_default,
  # DEPRECATED PARAMETERS
  $zeromq_port            = undef,
  $kombu_ssl_version      = undef,
  $kombu_ssl_keyfile      = undef,
  $kombu_ssl_certfile     = undef,
  $kombu_ssl_ca_certs     = undef,
  $kombu_reconnect_delay  = undef,
) {

  warning('This class is deprecated. Use sahara::init for configuration rpc options instead')
  warning('The default for zeromq_host parameter is different from OpenStack project default')

  if $zeromq_port {
    warning('The zeromq_port parameter is deprecated and has no effect.')
  }

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
    'DEFAULT/rpc_backend':           value => 'zmq';
    'DEFAULT/rpc_zmq_bind_address':  value => $zeromq_bind_address;
    'DEFAULT/rpc_zmq_contexts':      value => $zeromq_contexts;
    'DEFAULT/rpc_zmq_topic_backlog': value => $zeromq_topic_backlog;
    'DEFAULT/rpc_zmq_ipc_dir':       value => $zeromq_ipc_dir;
    'DEFAULT/rpc_zmq_host':          value => $zeromq_host;
    'DEFAULT/rpc_cast_timeout':      value => $cast_timeout;
  }
}
