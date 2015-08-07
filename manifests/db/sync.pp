#
# Class to execute sahara dbsync
#
class sahara::db::sync {

  include ::sahara::params

  Package <| tag == 'sahara-package' |> ~> Exec['sahara-dbmanage']
  Exec['sahara-dbmanage'] ~> Service <| tag == 'sahara-service' |>

  Sahara_config <||> -> Exec['sahara-dbmanage']
  Sahara_config <| title == 'database/connection' |> ~> Exec['sahara-dbmanage']

  exec { 'sahara-dbmanage':
    command     => $::sahara::params::dbmanage_command,
    path        => '/usr/bin',
    user        => 'sahara',
    refreshonly => true,
    logoutput   => on_failure,
  }

}
