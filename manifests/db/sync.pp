#
# Class to execute sahara dbsync
#
# == Parameters
#
# [*extra_params*]
#   (optional) String of extra command line parameters to append
#   to the sahara-db-manage command.
#   Defaults to '--config-file /etc/sahara/sahara.conf'
#
class sahara::db::sync(
  $extra_params = '--config-file /etc/sahara/sahara.conf',
) {

  include ::sahara::params

  Package <| tag == 'sahara-package' |> ~> Exec['sahara-dbmanage']
  Exec['sahara-dbmanage'] ~> Service <| tag == 'sahara-service' |>

  Sahara_config <||> -> Exec['sahara-dbmanage']
  Sahara_config <| title == 'database/connection' |> ~> Exec['sahara-dbmanage']

  exec { 'sahara-dbmanage':
    command     => "sahara-db-manage ${extra_params} upgrade head",
    path        => '/usr/bin',
    user        => 'sahara',
    refreshonly => true,
    try_sleep   => 5,
    tries       => 10,
    logoutput   => on_failure,
    tag         => 'openstack-db',
  }

}
