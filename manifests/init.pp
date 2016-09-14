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
#   If set to boolean false, it will not log to any directory.
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
# [*use_neutron*]
#   (Optional) Whether to use neutron
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
# == keystone authentication options
#
# [*admin_user*]
#   (Optional) Service user name
#   Defaults to 'sahara'.
#
# [*admin_password*]
#   (Optional) Service user password.
#   Defaults to false.
#
# [*admin_tenant_name*]
#   (Optional) Service tenant name.
#   Defaults to 'services'.
#
# [*auth_uri*]
#   (Optional) Complete public Identity API endpoint.
#   Defaults to 'http://127.0.0.1:5000/v2.0/'.
#
# [*identity_uri*]
#   (Optional) Complete admin Identity API endpoint.
#   This should specify the unversioned root endpoint.
#   Defaults to 'http://127.0.0.1:35357/'.
#
# [*memcached_servers*]
#   (optinal) a list of memcached server(s) to use for caching. If left
#   undefined, tokens will instead be cached in-process.
#   Defaults to $::os_service_default.
#
# == rpc backend options
#
# [*default_transport_url*]
#    (optional) A URL representing the messaging driver to use and its full
#    configuration. Transport URLs take the form:
#      transport://user:pass@host1:port[,hostN:portN]/virtual_host
#    Defaults to $::os_service_default
#
# [*control_exchange*]
#   (Optional) The default exchange to scope topics.
#   Defaults to $::os_service_default.
#
# [*rpc_backend*]
#   (optional) The rpc backend implementation to use, can be:
#     amqp (for AMQP 1.0)
#     rabbit (for rabbitmq)
#     zmq (for zeromq)
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
# == DEPRECATED PARAMETERS
#
# [*verbose*]
#   (Optional) Deprecated. Should the daemons log verbose messages
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
  $use_neutron                 = $::os_service_default,
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
  $admin_user                  = 'sahara',
  $admin_password              = false,
  $admin_tenant_name           = 'services',
  $auth_uri                    = 'http://127.0.0.1:5000/v2.0/',
  $identity_uri                = 'http://127.0.0.1:35357/',
  $memcached_servers           = $::os_service_default,
  $default_transport_url       = $::os_service_default,
  $control_exchange            = $::os_service_default,
  $rpc_backend                 = $::os_service_default,
  $amqp_durable_queues         = $::os_service_default,
  $rabbit_ha_queues            = $::os_service_default,
  $rabbit_host                 = $::os_service_default,
  $rabbit_hosts                = $::os_service_default,
  $rabbit_port                 = $::os_service_default,
  $rabbit_use_ssl              = $::os_service_default,
  $rabbit_userid               = $::os_service_default,
  $rabbit_password             = $::os_service_default,
  $rabbit_login_method         = $::os_service_default,
  $rabbit_virtual_host         = $::os_service_default,
  $rabbit_retry_interval       = $::os_service_default,
  $rabbit_retry_backoff        = $::os_service_default,
  $rabbit_max_retries          = $::os_service_default,
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
  # DEPRECATED PARAMETERS
  $verbose                     = undef,
) {
  include ::sahara::params
  include ::sahara::logging
  include ::sahara::db
  include ::sahara::policy

  if $verbose {
    warning('verbose is deprecated, has no effect and will be removed after Newton cycle.')
  }

  package { 'sahara-common':
    ensure => $package_ensure,
    name   => $::sahara::params::common_package_name,
    tag    => ['openstack', 'sahara-package'],
  }

  Package['sahara-common'] -> Class['sahara::policy']

  resources { 'sahara_config':
    purge => $purge_config,
  }

  sahara_config {
    'DEFAULT/plugins':          value => join(any2array($plugins),',');
    'DEFAULT/use_neutron':      value => $use_neutron;
    'DEFAULT/use_floating_ips': value => $use_floating_ips;
    'DEFAULT/host':             value => $host;
    'DEFAULT/port':             value => $port;
  }

  if $admin_password {
    sahara_config {
      'keystone_authtoken/auth_uri':          value => $auth_uri;
      'keystone_authtoken/identity_uri':      value => $identity_uri;
      'keystone_authtoken/admin_user':        value => $admin_user;
      'keystone_authtoken/admin_tenant_name': value => $admin_tenant_name;
      'keystone_authtoken/admin_password':
        value  => $admin_password,
        secret => true;
      'keystone_authtoken/memcached_servers': value => join(any2array($memcached_servers), ',');
    }
  }

  oslo::messaging::default { 'sahara_config':
    transport_url    => $default_transport_url,
    control_exchange => $control_exchange,
  }

  if $rpc_backend == 'rabbit' or is_service_default($rpc_backend) {
    oslo::messaging::rabbit { 'sahara_config':
      rabbit_userid           => $rabbit_userid,
      rabbit_password         => $rabbit_password,
      rabbit_virtual_host     => $rabbit_virtual_host,
      rabbit_host             => $rabbit_host,
      rabbit_port             => $rabbit_port,
      rabbit_hosts            => $rabbit_hosts,
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
      rabbit_max_retries      => $rabbit_max_retries,
    }
  }

  if $rpc_backend == 'zmq' {
    oslo::messaging::zmq { 'sahara_config':
      rpc_zmq_bind_address  => $zeromq_bind_address,
      rpc_zmq_contexts      => $zeromq_contexts,
      rpc_zmq_topic_backlog => $zeromq_topic_backlog,
      rpc_zmq_ipc_dir       => $zeromq_ipc_dir,
      rpc_zmq_host          => $zeromq_host,
      rpc_cast_timeout      => $cast_timeout,
    }
  }

  if $rpc_backend == 'amqp' {
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
