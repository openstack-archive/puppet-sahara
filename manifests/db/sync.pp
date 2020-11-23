#
# Class to execute sahara dbsync
#
# == Parameters
#
# [*extra_params*]
#   (Optional) String of extra command line parameters to append
#   to the sahara-db-manage command.
#   Defaults to '--config-file /etc/sahara/sahara.conf'
#
# [*db_sync_timeout*]
#   (Optional) Timeout for the execution of the db_sync
#   Defaults to 300
#
class sahara::db::sync(
  $extra_params    = '--config-file /etc/sahara/sahara.conf',
  $db_sync_timeout = 300,
) {

  include sahara::deps

  exec { 'sahara-dbmanage':
    command     => "sahara-db-manage ${extra_params} upgrade head",
    path        => '/usr/bin',
    user        => 'sahara',
    refreshonly => true,
    try_sleep   => 5,
    tries       => 10,
    timeout     => $db_sync_timeout,
    logoutput   => on_failure,
    subscribe   => [
      Anchor['sahara::install::end'],
      Anchor['sahara::config::end'],
      Anchor['sahara::dbsync::begin']
    ],
    notify      => Anchor['sahara::dbsync::end'],
    tag         => 'openstack-db',
  }

}
