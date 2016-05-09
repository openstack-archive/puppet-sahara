# == Class: sahara:db
#
# Configure the Sahara database
#
# == Parameters
#
# [*database_db_max_retries*]
#   (optional) Maximum retries in case of connection error or deadlock error
#   before error is raised. Set to -1 to specify an infinite retry count.
#   Defaults to $::os_service_default
#
# [*database_connection*]
#   (Optional) The connection string to use to connect to the database.
#   Defaults to 'mysql+pymysql://sahara:secrete@localhost:3306/sahara'
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
  $database_db_max_retries = $::os_service_default,
  $database_connection     = 'mysql+pymysql://sahara:secrete@localhost:3306/sahara',
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

  validate_re($database_connection_real,
    '^(mysql(\+pymysql)?|postgresql):\/\/(\S+:\S+@\S+\/\S+)?')

  oslo::db { 'sahara_config':
    db_max_retries => $database_db_max_retries,
    connection     => $database_connection_real,
    idle_timeout   => $database_idle_timeout_real,
    min_pool_size  => $database_min_pool_size_real,
    max_pool_size  => $database_max_pool_size_real,
    max_retries    => $database_max_retries_real,
    retry_interval => $database_retry_interval_real,
    max_overflow   => $database_max_overflow_real,
  }
}
