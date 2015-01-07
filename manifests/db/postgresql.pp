# == Class: sahara::db:postgresql
#
# The sahara::db::postgresql creates a PostgreSQL database for sahara.
# It must be used on the PostgreSQL server.
#
# === Parameters
#
# [*password*]
#   (Mandatory) Password to connect to the database.
#   Defaults to 'false'.
#
# [*dbname*]
#   (Optional) Name of the database.
#   Defaults to 'sahara'.
#
# [*user*]
#   (Optional) User to connect to the database.
#   Defaults to 'sahara'.
#
class sahara::db::postgresql (
  $password,
  $dbname = 'sahara',
  $user   = 'sahara',
) {

  require postgresql::lib::python
  validate_string($password)

  postgresql::server::db { $dbname:
    user     => $user,
    password => postgresql_password($user, $password),
  }

  PostgreSQL::Server::Db[$dbname] ~> Exec<| title == 'sahara-dbmanage' |>
  Package['python-psycopg2'] -> Exec<| title == 'sahara-dbmanage' |>
}
