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
#   Defaults to '0.0.0.0'.
#
# [*port*]
#   (Optional) Port for sahara to listen on
#   Defaults to 8386.
#
# [*plugins*]
#   (Optional) List of plugins to be loaded.
#   Sahara preserves the order of the list when returning it.
#   Defaults to $::os_service_default
#
# [*use_neutron*]
#   (Optional) Whether to use neutron
#   Defaults to 'false'.
#
# [*use_floating_ips*]
#   (Optional) Whether to use floating IPs to communicate with instances.
#   Defaults to 'true'.
#
# [*use_ssl*]
#   (optional) Enable SSL on the API server
#   Defaults to false, not set
#
# [*cert_file*]
#   (optinal) Certificate file to use when starting API server securely
#   Defaults to $::os_service_default
#
# [*key_file*]
#   (optional) Private key file to use when starting API server securely
#   Defaults to $::os_service_default
#
# [*ca_file*]
#   (optional) CA certificate file to use to verify connecting clients
#   Defaults to $::os_service_default
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
#   Defaults to $::os_service_default
#
# [*amqp_durable_queues*]
#   (optional) Use durable queues in AMQP
#   Defaults to false.
#
# [*rabbit_ha_queues*]
#   (Optional) Use durable queues in RabbitMQ.
#   Defaults to false.
#
# [*rabbit_host*]
#   (Optional) IP or hostname of the rabbit server.
#   Defaults to '127.0.0.1'.
#
# [*rabbit_port*]
#   (Optional) Port of the rabbit server.
#   Defaults to 5672.
#
# [*rabbit_hosts*]
#   (Optional) IP or hostname of the rabbits servers.
#   comma separated array (ex: ['1.0.0.10:5672','1.0.0.11:5672'])
#   Defaults to false.
#
# [*rabbit_use_ssl*]
#   (Optional) Connect over SSL for RabbitMQ.
#   Defaults to false.
#
# [*rabbit_userid*]
#   (Optional) User to connect to the rabbit server.
#   Defaults to 'guest'.
#
# [*rabbit_password*]
#   (Optional) Password to connect to the rabbit server.
#   Defaults to 'guest'.
#
# [*rabbit_login_method*]
#   (Optional) Method to auth with the rabbit server.
#   Defaults to 'AMQPLAIN'.
#
# [*rabbit_virtual_host*]
#   (Optional) Virtual host to use.
#   Defaults to '/'.
#
# [*rabbit_retry_interval*]
#   (Optional) Reconnection attempt frequency for rabbit.
#   Defaults to 1.
#
# [*rabbit_retry_backoff*]
#   (Optional) Backoff between reconnection attempts for rabbit.
#   Defaults to 2.
#
# [*rabbit_max_retries*]
#   (Optional) Number of times to retry (0 == no limit).
#   Defaults to 0.
#
# [*qpid_hostname*]
#   (Optional) IP or hostname of the qpid server.
#   Defaults to '127.0.0.1'.
#
# [*qpid_port*]
#   (Optional) Port of the qpid server.
#   Defaults to 5672.
#
# [*qpid_hosts*]
#   (Optional) Qpid HA cluster host:port pairs..
#   comma separated array (ex: ['1.0.0.10:5672','1.0.0.11:5672'])
#   Defaults to false.
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
# [*zeromq_bind_address*]
#   (Optional) Bind address; wildcard, ethernet, or ip address.
#   Defaults to '*'.
#
# [*zeromq_port*]
#   (Optional) Receiver listening port.
#   Defaults to 9501.
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
# [*manage_service*]
#   (optional) Whether the service should be managed by Puppet.
#   Defaults to undef.
#
# [*enabled*]
#   (optional) Should the service be enabled.
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
  $host                    = '0.0.0.0',
  $port                    = '8386',
  $plugins                 = $::os_service_default,
  $use_neutron             = false,
  $use_floating_ips        = true,
  $use_ssl                 = false,
  $ca_file                 = $::os_service_default,
  $cert_file               = $::os_service_default,
  $key_file                = $::os_service_default,
  $database_connection     = undef,
  $database_max_retries    = undef,
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
  $amqp_durable_queues     = false,
  $rabbit_ha_queues        = false,
  $rabbit_host             = 'localhost',
  $rabbit_hosts            = false,
  $rabbit_port             = 5672,
  $rabbit_use_ssl          = false,
  $rabbit_userid           = 'guest',
  $rabbit_password         = 'guest',
  $rabbit_login_method     = 'AMQPLAIN',
  $rabbit_virtual_host     = '/',
  $rabbit_retry_interval   = 1,
  $rabbit_retry_backoff    = 2,
  $rabbit_max_retries      = 0,
  $qpid_hostname           = 'localhost',
  $qpid_port               = 5672,
  $qpid_hosts              = false,
  $qpid_username           = 'guest',
  $qpid_password           = 'guest',
  $qpid_sasl_mechanisms    = '',
  $qpid_heartbeat          = 60,
  $qpid_protocol           = 'tcp',
  $qpid_tcp_nodelay        = true,
  $qpid_receiver_capacity  = 1,
  $qpid_topology_version   = 2,
  $zeromq_bind_address     = '*',
  $zeromq_port             = 9501,
  $zeromq_contexts         = 1,
  $zeromq_topic_backlog    = 'None',
  $zeromq_ipc_dir          = '/var/run/openstack',
  $zeromq_host             = 'sahara',
  $cast_timeout            = 30,
  $kombu_ssl_version       = $::os_service_default,
  $kombu_ssl_keyfile       = $::os_service_default,
  $kombu_ssl_certfile      = $::os_service_default,
  $kombu_ssl_ca_certs      = $::os_service_default,
  $kombu_reconnect_delay   = '1.0',
  # DEPRECATED PARAMETERS
  $manage_service      = undef,
  $enabled             = undef,
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
    if $rabbit_hosts {
      sahara_config {
        'oslo_messaging_rabbit/rabbit_hosts':     value => join($rabbit_hosts, ',');
        'oslo_messaging_rabbit/rabbit_ha_queues': value => true;
      }
    } else {
      sahara_config {
        'oslo_messaging_rabbit/rabbit_host':      value => $rabbit_host;
        'oslo_messaging_rabbit/rabbit_port':      value => $rabbit_port;
        'oslo_messaging_rabbit/rabbit_ha_queues': value => $rabbit_ha_queues;
        'oslo_messaging_rabbit/rabbit_hosts':     value => "${rabbit_host}:${rabbit_port}";
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

    if $qpid_hosts {
      sahara_config {
        'oslo_messaging_qpid/qpid_hosts':     value => join($qpid_hosts, ',');
      }
    } else {
      sahara_config {
        'oslo_messaging_qpid/qpid_hostname': value => $qpid_hostname;
        'oslo_messaging_qpid/qpid_port':     value => $qpid_port;
        'oslo_messaging_qpid/qpid_hosts':    value => "${qpid_hostname}:${qpid_port}";
      }
    }

    sahara_config {
      'DEFAULT/rpc_backend':                     value => 'qpid';
      'oslo_messaging_qpid/amqp_durable_queues': value => $amqp_durable_queues;
      'oslo_messaging_qpid/qpid_username':       value => $qpid_username;
      'oslo_messaging_qpid/qpid_password':
        value => $qpid_password,
        secret => true;
      'oslo_messaging_qpid/qpid_sasl_mechanisms':   value => $qpid_sasl_mechanisms;
      'oslo_messaging_qpid/qpid_heartbeat':         value => $qpid_heartbeat;
      'oslo_messaging_qpid/qpid_protocol':          value => $qpid_protocol;
      'oslo_messaging_qpid/qpid_tcp_nodelay':       value => $qpid_tcp_nodelay;
      'oslo_messaging_qpid/qpid_receiver_capacity': value => $qpid_receiver_capacity;
      'oslo_messaging_qpid/qpid_topology_version':  value => $qpid_topology_version;
    }
  }

  if $rpc_backend == 'zmq' {
    sahara_config {
      'DEFAULT/rpc_backend':           value => 'zmq';
      'DEFAULT/rpc_zmq_bind_address':  value => $zeromq_bind_address;
      'DEFAULT/rpc_zmq_port':          value => $zeromq_port;
      'DEFAULT/rpc_zmq_contexts':      value => $zeromq_contexts;
      'DEFAULT/rpc_zmq_topic_backlog': value => $zeromq_topic_backlog;
      'DEFAULT/rpc_zmq_ipc_dir':       value => $zeromq_ipc_dir;
      'DEFAULT/rpc_zmq_host':          value => $zeromq_host;
      'DEFAULT/rpc_cast_timeout':      value => $cast_timeout;
    }
  }

  if $use_ssl {
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

  if $manage_service or $enabled {
    warning('Configuring daemon services from init class is deprecated.')
    warning('Use ::sahara::service::{all|api|engine}.pp for configuring daemon services instead.')
    class { '::sahara::service::all':
      enabled        => $enabled,
      manage_service => $manage_service,
      package_ensure => $package_ensure,
    }
  }
}
