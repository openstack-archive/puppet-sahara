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
# [*verbose*]
#   (Optional) Should the daemons log verbose messages
#   Defaults to undef.
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
# == rpc backend options
#
# [*rpc_backend*]
#   (optional) The rpc backend implementation to use, can be:
#     rabbit (for rabbitmq)
#     qpid (for qpid)
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
#   Defaults to '1.0'; floating-point value.
#
# == DEPRECATED PARAMETERS
#
# [*zeromq_port*]
#   (Optional) Receiver listening port.
#   Defaults to undef.
#
# [*qpid_hostname*]
#   (Optional) IP or hostname of the qpid server.
#   Defaults to undef.
#
# [*qpid_port*]
#   (Optional) Port of the qpid server.
#   Defaults to undef.
#
# [*qpid_hosts*]
#   (Optional) Qpid HA cluster host:port pairs..
#   comma separated array (ex: ['1.0.0.10:5672','1.0.0.11:5672'])
#   Defaults to undef.
#
# [*qpid_username*]
#   (Optional) User to connect to the qpid server.
#   Defaults to undef.
#
# [*qpid_password*]
#   (Optional) Password to connect to the qpid server.
#   Defaults to undef.
#
# [*qpid_sasl_mechanisms*]
#   (Optional) String of SASL mechanisms to use.
#   Defaults to undef.
#
# [*qpid_heartbeat*]
#   (Optional) Seconds between connection keepalive heartbeats.
#   Defaults to undef.
#
# [*qpid_protocol*]
#   (Optional) Protocol to use for qpid (tcp/ssl).
#   Defaults to undef.
#
# [*qpid_tcp_nodelay*]
#   (Optional) Whether to disable the Nagle algorithm.
#   Defaults to undef.
#
# [*qpid_receiver_capacity*]
#   (Optional) Number of prefetched messages to hold.
#   Defaults to undef.
#
# [*qpid_topology_version*]
#   (Optional) Version of qpid toplogy to use.
#   Defaults to undef.
#
class sahara(
  $package_ensure          = 'present',
  $verbose                 = undef,
  $debug                   = undef,
  $use_syslog              = undef,
  $use_stderr              = undef,
  $log_facility            = undef,
  $log_dir                 = undef,
  $host                    = $::os_service_default,
  $port                    = $::os_service_default,
  $plugins                 = $::os_service_default,
  $use_neutron             = $::os_service_default,
  $use_floating_ips        = $::os_service_default,
  $use_ssl                 = $::os_service_default,
  $ca_file                 = $::os_service_default,
  $cert_file               = $::os_service_default,
  $key_file                = $::os_service_default,
  $database_connection     = undef,
  $database_idle_timeout   = undef,
  $database_min_pool_size  = undef,
  $database_max_pool_size  = undef,
  $database_max_retries    = undef,
  $database_retry_interval = undef,
  $database_max_overflow   = undef,
  $sync_db                 = true,
  $admin_user              = 'sahara',
  $admin_password          = false,
  $admin_tenant_name       = 'services',
  $auth_uri                = 'http://127.0.0.1:5000/v2.0/',
  $identity_uri            = 'http://127.0.0.1:35357/',
  $rpc_backend             = $::os_service_default,
  $amqp_durable_queues     = $::os_service_default,
  $rabbit_ha_queues        = $::os_service_default,
  $rabbit_host             = $::os_service_default,
  $rabbit_hosts            = $::os_service_default,
  $rabbit_port             = $::os_service_default,
  $rabbit_use_ssl          = $::os_service_default,
  $rabbit_userid           = $::os_service_default,
  $rabbit_password         = $::os_service_default,
  $rabbit_login_method     = $::os_service_default,
  $rabbit_virtual_host     = $::os_service_default,
  $rabbit_retry_interval   = $::os_service_default,
  $rabbit_retry_backoff    = $::os_service_default,
  $rabbit_max_retries      = $::os_service_default,
  $zeromq_bind_address     = $::os_service_default,
  $zeromq_contexts         = $::os_service_default,
  $zeromq_topic_backlog    = $::os_service_default,
  $zeromq_ipc_dir          = $::os_service_default,
  $zeromq_host             = 'sahara',
  $cast_timeout            = $::os_service_default,
  $kombu_ssl_version       = $::os_service_default,
  $kombu_ssl_keyfile       = $::os_service_default,
  $kombu_ssl_certfile      = $::os_service_default,
  $kombu_ssl_ca_certs      = $::os_service_default,
  $kombu_reconnect_delay   = $::os_service_default,
  # DEPRECATED PARAMETERS
  $zeromq_port             = undef,
  $qpid_hostname           = undef,
  $qpid_port               = undef,
  $qpid_hosts              = undef,
  $qpid_username           = undef,
  $qpid_password           = undef,
  $qpid_sasl_mechanisms    = undef,
  $qpid_heartbeat          = undef,
  $qpid_protocol           = undef,
  $qpid_tcp_nodelay        = undef,
  $qpid_receiver_capacity  = undef,
  $qpid_topology_version   = undef,
) {
  include ::sahara::params
  include ::sahara::logging
  include ::sahara::db
  include ::sahara::policy

  package { 'sahara-common':
    ensure => $package_ensure,
    name   => $::sahara::params::common_package_name,
    tag    => ['openstack', 'sahara-package'],
  }

  Package['sahara-common'] -> Class['sahara::policy']

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
        value => $admin_password,
        secret => true;
    }
  }

  if $rpc_backend == 'rabbit' or is_service_default($rpc_backend) {
    if ! is_service_default($rabbit_hosts) and $rabbit_hosts {
      sahara_config {
        'oslo_messaging_rabbit/rabbit_hosts':     value => join(any2array($rabbit_hosts), ',');
        'oslo_messaging_rabbit/rabbit_ha_queues': value => true;
      }
    } else {
      sahara_config {
        'oslo_messaging_rabbit/rabbit_host':      value => $rabbit_host;
        'oslo_messaging_rabbit/rabbit_port':      value => $rabbit_port;
        'oslo_messaging_rabbit/rabbit_ha_queues': value => $rabbit_ha_queues;
        'oslo_messaging_rabbit/rabbit_hosts':     ensure => absent;
      }
    }
    sahara_config {
      'DEFAULT/rpc_backend':                       value => 'rabbit';
      'oslo_messaging_rabbit/amqp_durable_queues': value => $amqp_durable_queues;
      'oslo_messaging_rabbit/rabbit_use_ssl':      value => $rabbit_use_ssl;
      'oslo_messaging_rabbit/rabbit_userid':       value => $rabbit_userid;
      'oslo_messaging_rabbit/rabbit_password':
        value => $rabbit_password,
        secret => true;
      'oslo_messaging_rabbit/rabbit_login_method':   value => $rabbit_login_method;
      'oslo_messaging_rabbit/rabbit_virtual_host':   value => $rabbit_virtual_host;
      'oslo_messaging_rabbit/rabbit_retry_interval': value => $rabbit_retry_interval;
      'oslo_messaging_rabbit/rabbit_retry_backoff':  value => $rabbit_retry_backoff;
      'oslo_messaging_rabbit/rabbit_max_retries':    value => $rabbit_max_retries;
      'oslo_messaging_rabbit/kombu_ssl_ca_certs':    value => $kombu_ssl_ca_certs;
      'oslo_messaging_rabbit/kombu_ssl_certfile':    value => $kombu_ssl_certfile;
      'oslo_messaging_rabbit/kombu_ssl_keyfile':     value => $kombu_ssl_keyfile;
      'oslo_messaging_rabbit/kombu_ssl_version':     value => $kombu_ssl_version;
      'oslo_messaging_rabbit/kombu_reconnect_delay': value => $kombu_reconnect_delay;
    }
  }

  if $rpc_backend == 'qpid' {
    warning('Qpid driver is removed from Oslo.messaging in the Mitaka release')
  }

  if $rpc_backend == 'zmq' {

    if $zeromq_port {
      warning('The zeromq_port parameter is deprecated and has no effect.')
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

  if ! is_service_default($use_ssl) and $use_ssl {
    if is_service_default($ca_file) {
      fail('The ca_file parameter is required when use_ssl is set to true')
    }
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
