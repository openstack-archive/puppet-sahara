# == Class: sahara:db
#
# Configure the Sahara database
#
# == Parameters
#
# [*database_connection*]
#   (Optional) The connection string to use to connect to the database.
#   Defaults to mysql://sahara:secrete@localhost:3306/sahara.
#
# [*database_max_retries*]
#   (Optional) Maximum number of database connection retries during startup.
#   Set to -1 to specify an infinite retry count.
#   Defaults to $::os_service_default.
#
# [*database_idle_timeout*]
#   (Optional) Timeout before idle SQL connections are reaped.
#   Defaults to $::os_service_default.
#
# [*database_retry_interval*]
#   (optional) Interval between retries of opening a database connection.
#   Defaults to $::os_service_default.
#
# [*database_min_pool_size*]
#   (optional) Minimum number of SQL connections to keep open in a pool.
#   Defaults to $::os_service_default.
#
# [*database_max_pool_size*]
#   (optional) Maximum number of SQL connections to keep open in a pool.
#   Defaults to $::os_service_default.
#
# [*database_max_overflow*]
#   (optional) If set, use this value for max_overflow with sqlalchemy.
#   Defaults to $::os_service_default.
#
class sahara::db (
  $database_connection     = 'mysql://sahara:secrete@localhost:3306/sahara',
  $database_idle_timeout   = $::os_service_default,
  $database_min_pool_size  = $::os_service_default,
  $database_max_pool_size  = $::os_service_default,
  $database_max_retries    = $::os_service_default,
  $database_retry_interval = $::os_service_default,
  $database_max_overflow   = $::os_service_default,
) {

  # NOTE(degorenko): In order to keep backward compatibility we rely on the pick function
  # to use sahara::<myparam> if sahara::db::<myparam> isn't specified.
  $database_connection_real     = pick($::sahara::database_connection, $database_connection)
  $database_idle_timeout_real   = pick($::sahara::database_idle_timeout, $database_idle_timeout)
  $database_min_pool_size_real  = pick($::sahara::database_min_pool_size, $database_min_pool_size)
  $database_max_pool_size_real  = pick($::sahara::database_max_pool_size, $database_max_pool_size)
  $database_max_retries_real    = pick($::sahara::database_max_retries, $database_max_retries)
  $database_retry_interval_real = pick($::sahara::database_retry_interval, $database_retry_interval)
  $database_max_overflow_real   = pick($::sahara::database_max_overflow, $database_max_overflow)

  validate_re($database_connection_real, '(mysql|postgresql):\/\/(\S+:\S+@\S+\/\S+)?')

  case $database_connection_real {
    /^mysql:\/\//: {
      $backend_package = false
      require mysql::bindings
      require mysql::bindings::python
    }
    /^postgresql:\/\//: {
      $backend_package = false
      require postgresql::lib::python
    }
    default: {
      fail('Unsupported db backend configured')
    }
  }

  if $backend_package and !defined(Package[$backend_package]) {
    package {'sahara-backend-package':
      ensure => present,
      name   => $backend_package,
      tag    => 'openstack',
    }
  }

  sahara_config {
    'database/connection':     value => $database_connection_real, secret => true;
    'database/idle_timeout':   value => $database_idle_timeout_real;
    'database/min_pool_size':  value => $database_min_pool_size_real;
    'database/max_retries':    value => $database_max_retries_real;
    'database/retry_interval': value => $database_retry_interval_real;
    'database/max_pool_size':  value => $database_max_pool_size_real;
    'database/max_overflow':   value => $database_max_overflow_real;
  }

}
