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
# [*debug*]
#   (Optional) Should the daemons log debug messages
#   Defaults to undef.
#
# [*use_syslog*]
#   Use syslog for logging.
#   (Optional) Defaults to undef.
#
# [*use_stderr*]
#   (optional) Use stderr for logging
#   Defaults to undef
#
# [*log_facility*]
#   Syslog facility to receive log lines.
#   (Optional) Defaults to undef.
#
# [*log_dir*]
#   (optional) Directory where logs should be stored.
#   If set to $::os_service_default, it will not log to any directory.
#   Defaults to undef.
#
# [*host*]
#   (Optional) Hostname for sahara to listen on
#   Defaults to $::os_service_default.
#
# [*port*]
#   (Optional) Port for sahara to listen on
#   Defaults to $::os_service_default.
#
# [*plugins*]
#   (Optional) List of plugins to be loaded.
#   Sahara preserves the order of the list when returning it.
#   Defaults to $::os_service_default.
#
# [*use_floating_ips*]
#   (Optional) Whether to use floating IPs to communicate with instances.
#   Defaults to $::os_service_default.
#
# [*use_ssl*]
#   (optional) Enable SSL on the API server
#   Defaults to $::os_service_default, not set.
#
# [*cert_file*]
#   (optinal) Certificate file to use when starting API server securely
#   Defaults to $::os_service_default.
#
# [*key_file*]
#   (optional) Private key file to use when starting API server securely
#   Defaults to $::os_service_default.
#
# [*ca_file*]
#   (optional) CA certificate file to use to verify connecting clients
#   Defaults to $::os_service_default.
#
# == database configuration options
#
# [*database_connection*]
#   (Optional) Non-sqllite database for sahara
#   Defaults to undef.
#
# [*database_max_retries*]
#   (Optional) Maximum number of database connection retries during startup.
#   Set to -1 to specify an infinite retry count.
#   Defaults to undef.
#
# [*database_idle_timeout*]
#   (Optional) Timeout before idle SQL connections are reaped.
#   Defaults to undef.
#
# [*database_retry_interval*]
#   (optional) Interval between retries of opening a database connection.
#   Defaults to undef.
#
# [*database_min_pool_size*]
#   (optional) Minimum number of SQL connections to keep open in a pool.
#   Defaults to undef.
#
# [*database_max_pool_size*]
#   (optional) Maximum number of SQL connections to keep open in a pool.
#   Defaults to undef.
#
# [*database_max_overflow*]
#   (optional) If set, use this value for max_overflow with sqlalchemy.
#   Defaults to undef.
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
#    Defaults to $::os_service_default
#
# [*rpc_response_timeout*]
#  (Optional) Seconds to wait for a response from a call.
#  Defaults to $::os_service_default
#
# [*control_exchange*]
#   (Optional) The default exchange to scope topics.
#   Defaults to $::os_service_default.
#
# [*amqp_durable_queues*]
#   (optional) Use durable queues in AMQP
#   Defaults to $::os_service_default.
#
# [*rabbit_ha_queues*]
#   (Optional) Use durable queues in RabbitMQ.
#   Defaults to $::os_service_default.
#
# [*rabbit_use_ssl*]
#   (Optional) Connect over SSL for RabbitMQ.
#   Defaults to $::os_service_default.
#
# [*rabbit_login_method*]
#   (Optional) Method to auth with the rabbit server.
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
# [*zeromq_bind_address*]
#   (Optional) Bind address; wildcard, ethernet, or ip address.
#   Defaults to $::os_service_default.
#
# [*zeromq_contexts*]
#   (Optional) Number of contexsts for zeromq.
#   Defaults to $::os_service_default.
#
# [*zeromq_topic_backlog*]
#   (Optional) Number of incoming messages to buffer.
#   Defaults to $::os_service_default.
#
# [*zeromq_ipc_dir*]
#   (Optional) Directory for zeromq IPC.
#   Defaults to $::os_service_default.
#
# [*zeromq_host*]
#   (Optional) Name of the current node: hostname, FQDN, or IP.
#   Defaults to 'sahara'.
#
# [*cast_timeout*]
#   (Optional) TTL for zeromq messages.
#   Defaults to $::os_service_default.
#
#  [*kombu_ssl_version*]
#    (optional) SSL version to use (valid only if SSL enabled).
#    Valid values are TLSv1, SSLv23 and SSLv3. SSLv2 may be
#    available on some distributions.
#    Defaults to $::os_service_default.
#
# [*kombu_ssl_keyfile*]
#   (Optional) SSL key file (valid only if SSL enabled).
#   Defaults to $::os_service_default.
#
# [*kombu_ssl_certfile*]
#   (Optional) SSL cert file (valid only if SSL enabled).
#   Defaults to $::os_service_default.
#
# [*kombu_ssl_ca_certs*]
#   (Optional) SSL certification authority file (valid only if SSL enabled).
#   Defaults to $::os_service_default.
#
# [*kombu_reconnect_delay*]
#   (Optional) Backoff on cancel notification (valid only if SSL enabled).
#   (floating-point value)
#   Defaults to $::os_service_default.
#
# [*kombu_failover_strategy*]
#   (Optional) Determines how the next RabbitMQ node is chosen in case the one
#   we are currently connected to becomes unavailable. Takes effect only if
#   more than one RabbitMQ node is provided in config. (string value)
#   Defaults to $::os_service_default.
#
# [*kombu_compression*]
#   (optional) Possible values are: gzip, bz2. If not set compression will not
#   be used. This option may notbe available in future versions. EXPERIMENTAL.
#   (string value)
#   Defaults to $::os_service_default.
#
# [*amqp_server_request_prefix*]
#   (Optional) Address prefix used when sending to a specific server
#   Defaults to $::os_service_default.
#
# [*amqp_broadcast_prefix*]
#   (Optional) address prefix used when broadcasting to all servers
#   Defaults to $::os_service_default.
#
# [*amqp_group_request_prefix*]
#   (Optional) address prefix when sending to any server in group
#   Defaults to $::os_service_default.
#
# [*amqp_container_name*]
#   (Optional) Name for the AMQP container
#   Defaults to $::os_service_default.
#
# [*amqp_idle_timeout*]
#   (Optional) Timeout for inactive connections
#   Defaults to $::os_service_default.
#
# [*amqp_trace*]
#   (Optional) Debug: dump AMQP frames to stdout
#   Defaults to $::os_service_default.
#
# [*amqp_ssl_ca_file*]
#   (Optional) CA certificate PEM file to verify server certificate
#   Defaults to $::os_service_default.
#
# [*amqp_ssl_cert_file*]
#   (Optional) Identifying certificate PEM file to present to clients
#   Defaults to $::os_service_default.
#
# [*amqp_ssl_key_file*]
#   (Optional) Private key PEM file used to sign cert_file certificate
#   Defaults to $::os_service_default.
#
# [*amqp_ssl_key_password*]
#   (Optional) Password for decrypting ssl_key_file (if encrypted)
#   Defaults to $::os_service_default.
#
# [*amqp_allow_insecure_clients*]
#   (Optional) Accept clients using either SSL or plain TCP
#   Defaults to $::os_service_default.
#
# [*amqp_sasl_mechanisms*]
#   (Optional) Space separated list of acceptable SASL mechanisms
#   Defaults to $::os_service_default.
#
# [*amqp_sasl_config_dir*]
#   (Optional) Path to directory that contains the SASL configuration
#   Defaults to $::os_service_default.
#
# [*amqp_sasl_config_name*]
#   (Optional) Name of configuration file (without .conf suffix)
#   Defaults to $::os_service_default.
#
# [*amqp_username*]
#   (Optional) User name for message broker authentication
#   Defaults to $::os_service_default.
#
# [*amqp_password*]
#   (Optional) Password for message broker authentication
#   Defaults to $::os_service_default.
#
# [*purge_config*]
#   (optional) Whether to set only the specified config options
#   in the sahara config.
#   Defaults to false.
#
# [*default_ntp_server*]
#   (optional) default ntp server to be used by the cluster instances
#   Defaults to $::os_service_default
#
# === DEPRECATED PARAMETERS
#
# [*admin_user*]
#   (Optional) Service user name
#   Defaults to undef.
#
# [*admin_password*]
#   (Optional) Service user password.
#   Defaults to undef.
#
# [*admin_tenant_name*]
#   (Optional) Service tenant name.
#   Defaults to undef.
#
# [*auth_uri*]
#   (Optional) Complete public Identity API endpoint.
#   Defaults to undef.
#
# [*identity_uri*]
#   (Optional) Complete admin Identity API endpoint.
#   This should specify the unversioned root endpoint.
#   Defaults to undef.
#
# [*memcached_servers*]
#   (optinal) a list of memcached server(s) to use for caching. If left
#   undefined, tokens will instead be cached in-process.
#   Defaults to undef.
#
# [*use_neutron*]
#   (Optional) Whether to use neutron
#   Defaults to undef.
#
class sahara(
  $package_ensure              = 'present',
  $debug                       = undef,
  $use_syslog                  = undef,
  $use_stderr                  = undef,
  $log_facility                = undef,
  $log_dir                     = undef,
  $host                        = $::os_service_default,
  $port                        = $::os_service_default,
  $plugins                     = $::os_service_default,
  $use_floating_ips            = $::os_service_default,
  $use_ssl                     = $::os_service_default,
  $ca_file                     = $::os_service_default,
  $cert_file                   = $::os_service_default,
  $key_file                    = $::os_service_default,
  $database_connection         = undef,
  $database_idle_timeout       = undef,
  $database_min_pool_size      = undef,
  $database_max_pool_size      = undef,
  $database_max_retries        = undef,
  $database_retry_interval     = undef,
  $database_max_overflow       = undef,
  $sync_db                     = true,
  $default_transport_url       = $::os_service_default,
  $rpc_response_timeout        = $::os_service_default,
  $control_exchange            = $::os_service_default,
  $amqp_durable_queues         = $::os_service_default,
  $rabbit_ha_queues            = $::os_service_default,
  $rabbit_use_ssl              = $::os_service_default,
  $rabbit_login_method         = $::os_service_default,
  $rabbit_retry_interval       = $::os_service_default,
  $rabbit_retry_backoff        = $::os_service_default,
  $zeromq_bind_address         = $::os_service_default,
  $zeromq_contexts             = $::os_service_default,
  $zeromq_topic_backlog        = $::os_service_default,
  $zeromq_ipc_dir              = $::os_service_default,
  $zeromq_host                 = 'sahara',
  $cast_timeout                = $::os_service_default,
  $kombu_ssl_version           = $::os_service_default,
  $kombu_ssl_keyfile           = $::os_service_default,
  $kombu_ssl_certfile          = $::os_service_default,
  $kombu_ssl_ca_certs          = $::os_service_default,
  $kombu_reconnect_delay       = $::os_service_default,
  $kombu_failover_strategy     = $::os_service_default,
  $kombu_compression           = $::os_service_default,
  $amqp_server_request_prefix  = $::os_service_default,
  $amqp_broadcast_prefix       = $::os_service_default,
  $amqp_group_request_prefix   = $::os_service_default,
  $amqp_container_name         = $::os_service_default,
  $amqp_idle_timeout           = $::os_service_default,
  $amqp_trace                  = $::os_service_default,
  $amqp_ssl_ca_file            = $::os_service_default,
  $amqp_ssl_cert_file          = $::os_service_default,
  $amqp_ssl_key_file           = $::os_service_default,
  $amqp_ssl_key_password       = $::os_service_default,
  $amqp_allow_insecure_clients = $::os_service_default,
  $amqp_sasl_mechanisms        = $::os_service_default,
  $amqp_sasl_config_dir        = $::os_service_default,
  $amqp_sasl_config_name       = $::os_service_default,
  $amqp_username               = $::os_service_default,
  $amqp_password               = $::os_service_default,
  $purge_config                = false,
  $default_ntp_server          = $::os_service_default,
  # DEPRECATED PARAMETERS
  $admin_user                  = undef,
  $admin_password              = undef,
  $admin_tenant_name           = undef,
  $auth_uri                    = undef,
  $identity_uri                = undef,
  $memcached_servers           = undef,
  $use_neutron                 = undef,
) {

  include ::sahara::deps
  include ::sahara::params
  include ::sahara::logging
  include ::sahara::db
  include ::sahara::policy

  if $use_neutron {
    warning('The use_neutron parameter has been deprecated and will be removed in the future release.')
  }

  if $admin_user or $admin_password or
    $admin_tenant_name or $auth_uri or
    $identity_uri or $memcached_servers {
    warning("sahara::admin_user, sahara::admin_password, sahara::auth_uri, \
sahara::identity_uri, sahara::admin_tenant_name and sahara::memcached_servers are \
deprecated. Please use sahara::keystone::authtoken::* parameters instead.")
  }

  if $admin_password {
    include ::sahara::keystone::authtoken
  }

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
  }

  oslo::messaging::zmq { 'sahara_config':
    rpc_zmq_bind_address  => $zeromq_bind_address,
    rpc_zmq_contexts      => $zeromq_contexts,
    rpc_zmq_topic_backlog => $zeromq_topic_backlog,
    rpc_zmq_ipc_dir       => $zeromq_ipc_dir,
    rpc_zmq_host          => $zeromq_host,
    rpc_cast_timeout      => $cast_timeout,
  }

  oslo::messaging::amqp { 'sahara_config':
    server_request_prefix  => $amqp_server_request_prefix,
    broadcast_prefix       => $amqp_broadcast_prefix,
    group_request_prefix   => $amqp_group_request_prefix,
    container_name         => $amqp_container_name,
    idle_timeout           => $amqp_idle_timeout,
    trace                  => $amqp_trace,
    ssl_ca_file            => $amqp_ssl_ca_file,
    ssl_cert_file          => $amqp_ssl_cert_file,
    ssl_key_file           => $amqp_ssl_key_file,
    ssl_key_password       => $amqp_ssl_key_password,
    allow_insecure_clients => $amqp_allow_insecure_clients,
    sasl_mechanisms        => $amqp_sasl_mechanisms,
    sasl_config_dir        => $amqp_sasl_config_dir,
    sasl_config_name       => $amqp_sasl_config_name,
    username               => $amqp_username,
    password               => $amqp_password,
  }

  if ! is_service_default($use_ssl) and $use_ssl {
    if is_service_default($cert_file) {
      fail('The cert_file parameter is required when use_ssl is set to true')
    }
    if is_service_default($key_file) {
      fail('The key_file parameter is required when use_ssl is set to true')
    }
    sahara_config {
      'ssl/cert_file' : value => $cert_file;
      'ssl/key_file' :  value => $key_file;
      'ssl/ca_file' :   value => $ca_file;
    }
  }

  if $sync_db {
    include ::sahara::db::sync
  }

}
