# == Class: sahara
#
#  Sahara base package & configuration
#
# === Parameters
#
# [*package_ensure*]
#   (Optional) Ensure state for package
#   Defaults to 'present'.
#
# [*host*]
#   (Optional) Hostname for sahara to listen on
#   Defaults to $facts['os_service_default'].
#
# [*port*]
#   (Optional) Port for sahara to listen on
#   Defaults to $facts['os_service_default'].
#
# [*plugins*]
#   (Optional) List of plugins to be loaded.
#   Sahara preserves the order of the list when returning it.
#   Defaults to $facts['os_service_default'].
#
# [*use_floating_ips*]
#   (Optional) Whether to use floating IPs to communicate with instances.
#   Defaults to $facts['os_service_default'].
#
# [*node_domain*]
#   (Optional) The suffix of the node's FQDN.
#   Defaults to $facts['os_service_default'].
#
# [*use_designate*]
#   (Optional) Use Designate for internal and external hostnames resolution.
#   Defaults to $facts['os_service_default'].
#
# [*nameservers*]
#   (Optional) IP addresses of Designate nameservers.
#   Defaults to $facts['os_service_default'].
#
# [*use_ssl*]
#   (optional) Enable SSL on the API server
#   Defaults to false
#
# [*cert_file*]
#   (optinal) Certificate file to use when starting API server securely
#   Defaults to $facts['os_service_default'].
#
# [*key_file*]
#   (optional) Private key file to use when starting API server securely
#   Defaults to $facts['os_service_default'].
#
# [*ca_file*]
#   (optional) CA certificate file to use to verify connecting clients
#   Defaults to $facts['os_service_default'].
#
# == database configuration options
#
# [*sync_db*]
#   (Optional) Enable dbsync
#   Defaults to true.
#
# == rpc backend options
#
# [*default_transport_url*]
#    (optional) A URL representing the messaging driver to use and its full
#    configuration. Transport URLs take the form:
#      transport://user:pass@host1:port[,hostN:portN]/virtual_host
#    Defaults to $facts['os_service_default']
#
# [*rpc_response_timeout*]
#  (Optional) Seconds to wait for a response from a call.
#  Defaults to $facts['os_service_default']
#
# [*control_exchange*]
#   (Optional) The default exchange to scope topics.
#   Defaults to $facts['os_service_default'].
#
# [*amqp_durable_queues*]
#   (optional) Use durable queues in AMQP
#   Defaults to $facts['os_service_default'].
#
# [*rabbit_ha_queues*]
#   (Optional) Use durable queues in RabbitMQ.
#   Defaults to $facts['os_service_default'].
#
# [*rabbit_use_ssl*]
#   (Optional) Connect over SSL for RabbitMQ.
#   Defaults to $facts['os_service_default'].
#
# [*rabbit_login_method*]
#   (Optional) Method to auth with the rabbit server.
#   Defaults to $facts['os_service_default'].
#
# [*rabbit_retry_interval*]
#   (Optional) Reconnection attempt frequency for rabbit.
#   Defaults to $facts['os_service_default'].
#
# [*rabbit_retry_backoff*]
#   (Optional) Backoff between reconnection attempts for rabbit.
#   Defaults to $facts['os_service_default'].
#
# [*rabbit_heartbeat_in_pthread*]
#   (Optional) EXPERIMENTAL: Run the health check heartbeat thread
#   through a native python thread. By default if this
#   option isn't provided the  health check heartbeat will
#   inherit the execution model from the parent process. By
#   example if the parent process have monkey patched the
#   stdlib by using eventlet/greenlet then the heartbeat
#   will be run through a green thread.
#   Defaults to $facts['os_service_default']
#
#  [*kombu_ssl_version*]
#    (optional) SSL version to use (valid only if SSL enabled).
#    Valid values are TLSv1, SSLv23 and SSLv3. SSLv2 may be
#    available on some distributions.
#    Defaults to $facts['os_service_default'].
#
# [*kombu_ssl_keyfile*]
#   (Optional) SSL key file (valid only if SSL enabled).
#   Defaults to $facts['os_service_default'].
#
# [*kombu_ssl_certfile*]
#   (Optional) SSL cert file (valid only if SSL enabled).
#   Defaults to $facts['os_service_default'].
#
# [*kombu_ssl_ca_certs*]
#   (Optional) SSL certification authority file (valid only if SSL enabled).
#   Defaults to $facts['os_service_default'].
#
# [*kombu_reconnect_delay*]
#   (Optional) Backoff on cancel notification (valid only if SSL enabled).
#   (floating-point value)
#   Defaults to $facts['os_service_default'].
#
# [*kombu_failover_strategy*]
#   (Optional) Determines how the next RabbitMQ node is chosen in case the one
#   we are currently connected to becomes unavailable. Takes effect only if
#   more than one RabbitMQ node is provided in config. (string value)
#   Defaults to $facts['os_service_default'].
#
# [*kombu_compression*]
#   (optional) Possible values are: gzip, bz2. If not set compression will not
#   be used. This option may notbe available in future versions. EXPERIMENTAL.
#   (string value)
#   Defaults to $facts['os_service_default'].
#
# [*amqp_server_request_prefix*]
#   (Optional) Address prefix used when sending to a specific server
#   Defaults to $facts['os_service_default'].
#
# [*amqp_broadcast_prefix*]
#   (Optional) address prefix used when broadcasting to all servers
#   Defaults to $facts['os_service_default'].
#
# [*amqp_group_request_prefix*]
#   (Optional) address prefix when sending to any server in group
#   Defaults to $facts['os_service_default'].
#
# [*amqp_container_name*]
#   (Optional) Name for the AMQP container
#   Defaults to $facts['os_service_default'].
#
# [*amqp_idle_timeout*]
#   (Optional) Timeout for inactive connections
#   Defaults to $facts['os_service_default'].
#
# [*amqp_trace*]
#   (Optional) Debug: dump AMQP frames to stdout
#   Defaults to $facts['os_service_default'].
#
# [*amqp_ssl_ca_file*]
#   (Optional) CA certificate PEM file to verify server certificate
#   Defaults to $facts['os_service_default'].
#
# [*amqp_ssl_cert_file*]
#   (Optional) Identifying certificate PEM file to present to clients
#   Defaults to $facts['os_service_default'].
#
# [*amqp_ssl_key_file*]
#   (Optional) Private key PEM file used to sign cert_file certificate
#   Defaults to $facts['os_service_default'].
#
# [*amqp_ssl_key_password*]
#   (Optional) Password for decrypting ssl_key_file (if encrypted)
#   Defaults to $facts['os_service_default'].
#
# [*amqp_sasl_mechanisms*]
#   (Optional) Space separated list of acceptable SASL mechanisms
#   Defaults to $facts['os_service_default'].
#
# [*amqp_sasl_config_dir*]
#   (Optional) Path to directory that contains the SASL configuration
#   Defaults to $facts['os_service_default'].
#
# [*amqp_sasl_config_name*]
#   (Optional) Name of configuration file (without .conf suffix)
#   Defaults to $facts['os_service_default'].
#
# [*amqp_username*]
#   (Optional) User name for message broker authentication
#   Defaults to $facts['os_service_default'].
#
# [*amqp_password*]
#   (Optional) Password for message broker authentication
#   Defaults to $facts['os_service_default'].
#
# [*purge_config*]
#   (optional) Whether to set only the specified config options
#   in the sahara config.
#   Defaults to false.
#
# [*default_ntp_server*]
#   (optional) default ntp server to be used by the cluster instances
#   Defaults to $facts['os_service_default']
#
class sahara(
  $package_ensure              = 'present',
  $host                        = $facts['os_service_default'],
  $port                        = $facts['os_service_default'],
  $plugins                     = $facts['os_service_default'],
  $use_floating_ips            = $facts['os_service_default'],
  $node_domain                 = $facts['os_service_default'],
  $use_designate               = $facts['os_service_default'],
  $nameservers                 = $facts['os_service_default'],
  Boolean $use_ssl             = false,
  $ca_file                     = $facts['os_service_default'],
  $cert_file                   = $facts['os_service_default'],
  $key_file                    = $facts['os_service_default'],
  Boolean $sync_db             = true,
  $default_transport_url       = $facts['os_service_default'],
  $rpc_response_timeout        = $facts['os_service_default'],
  $control_exchange            = $facts['os_service_default'],
  $amqp_durable_queues         = $facts['os_service_default'],
  $rabbit_ha_queues            = $facts['os_service_default'],
  $rabbit_use_ssl              = $facts['os_service_default'],
  $rabbit_login_method         = $facts['os_service_default'],
  $rabbit_retry_interval       = $facts['os_service_default'],
  $rabbit_retry_backoff        = $facts['os_service_default'],
  $rabbit_heartbeat_in_pthread = $facts['os_service_default'],
  $kombu_ssl_version           = $facts['os_service_default'],
  $kombu_ssl_keyfile           = $facts['os_service_default'],
  $kombu_ssl_certfile          = $facts['os_service_default'],
  $kombu_ssl_ca_certs          = $facts['os_service_default'],
  $kombu_reconnect_delay       = $facts['os_service_default'],
  $kombu_failover_strategy     = $facts['os_service_default'],
  $kombu_compression           = $facts['os_service_default'],
  $amqp_server_request_prefix  = $facts['os_service_default'],
  $amqp_broadcast_prefix       = $facts['os_service_default'],
  $amqp_group_request_prefix   = $facts['os_service_default'],
  $amqp_container_name         = $facts['os_service_default'],
  $amqp_idle_timeout           = $facts['os_service_default'],
  $amqp_trace                  = $facts['os_service_default'],
  $amqp_ssl_ca_file            = $facts['os_service_default'],
  $amqp_ssl_cert_file          = $facts['os_service_default'],
  $amqp_ssl_key_file           = $facts['os_service_default'],
  $amqp_ssl_key_password       = $facts['os_service_default'],
  $amqp_sasl_mechanisms        = $facts['os_service_default'],
  $amqp_sasl_config_dir        = $facts['os_service_default'],
  $amqp_sasl_config_name       = $facts['os_service_default'],
  $amqp_username               = $facts['os_service_default'],
  $amqp_password               = $facts['os_service_default'],
  Boolean $purge_config        = false,
  $default_ntp_server          = $facts['os_service_default'],
) {

  include sahara::deps
  include sahara::params
  include sahara::db

  package { 'sahara-common':
    ensure => $package_ensure,
    name   => $::sahara::params::common_package_name,
    tag    => ['openstack', 'sahara-package'],
  }

  resources { 'sahara_config':
    purge => $purge_config,
  }

  sahara_config {
    'DEFAULT/plugins':            value => join(any2array($plugins),',');
    'DEFAULT/use_floating_ips':   value => $use_floating_ips;
    'DEFAULT/node_domain':        value => $node_domain;
    'DEFAULT/use_designate':      value => $use_designate;
    'DEFAULT/nameservers':        value => join(any2array($nameservers), ',');
    'DEFAULT/host':               value => $host;
    'DEFAULT/port':               value => $port;
    'DEFAULT/default_ntp_server': value => $default_ntp_server;
  }

  oslo::messaging::default { 'sahara_config':
    transport_url        => $default_transport_url,
    rpc_response_timeout => $rpc_response_timeout,
    control_exchange     => $control_exchange,
  }

  oslo::messaging::rabbit { 'sahara_config':
    rabbit_ha_queues        => $rabbit_ha_queues,
    rabbit_use_ssl          => $rabbit_use_ssl,
    kombu_failover_strategy => $kombu_failover_strategy,
    kombu_compression       => $kombu_compression,
    kombu_reconnect_delay   => $kombu_reconnect_delay,
    kombu_ssl_version       => $kombu_ssl_version,
    kombu_ssl_keyfile       => $kombu_ssl_keyfile,
    kombu_ssl_certfile      => $kombu_ssl_certfile,
    kombu_ssl_ca_certs      => $kombu_ssl_ca_certs,
    amqp_durable_queues     => $amqp_durable_queues,
    rabbit_login_method     => $rabbit_login_method,
    rabbit_retry_interval   => $rabbit_retry_interval,
    rabbit_retry_backoff    => $rabbit_retry_backoff,
    heartbeat_in_pthread    => $rabbit_heartbeat_in_pthread,
  }

  oslo::messaging::amqp { 'sahara_config':
    server_request_prefix => $amqp_server_request_prefix,
    broadcast_prefix      => $amqp_broadcast_prefix,
    group_request_prefix  => $amqp_group_request_prefix,
    container_name        => $amqp_container_name,
    idle_timeout          => $amqp_idle_timeout,
    trace                 => $amqp_trace,
    ssl_ca_file           => $amqp_ssl_ca_file,
    ssl_cert_file         => $amqp_ssl_cert_file,
    ssl_key_file          => $amqp_ssl_key_file,
    ssl_key_password      => $amqp_ssl_key_password,
    sasl_mechanisms       => $amqp_sasl_mechanisms,
    sasl_config_dir       => $amqp_sasl_config_dir,
    sasl_config_name      => $amqp_sasl_config_name,
    username              => $amqp_username,
    password              => $amqp_password,
  }

  if $use_ssl {
    if is_service_default($cert_file) {
      fail('The cert_file parameter is required when use_ssl is set to true')
    }
    if is_service_default($key_file) {
      fail('The key_file parameter is required when use_ssl is set to true')
    }
    sahara_config {
      'ssl/cert_file': value => $cert_file;
      'ssl/key_file':  value => $key_file;
      'ssl/ca_file':   value => $ca_file;
    }
  } else {
    sahara_config {
      'ssl/cert_file': ensure => absent;
      'ssl/key_file':  ensure => absent;
      'ssl/ca_file':   ensure => absent;
    }
  }

  if $sync_db {
    include sahara::db::sync
  }

}
