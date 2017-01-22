# == Class: sahara::deps
#
#  Sahara anchors and dependency management
#
class sahara::deps {
  # Setup anchors for install, config and service phases of the module.  These
  # anchors allow external modules to hook the begin and end of any of these
  # phases.  Package or service management can also be replaced by ensuring the
  # package is absent or turning off service management and having the
  # replacement depend on the appropriate anchors.  When applicable, end tags
  # should be notified so that subscribers can determine if installation,
  # config or service state changed and act on that if needed.
  anchor { 'sahara::install::begin': }
  -> Package<| tag == 'sahara-package'|>
  ~> anchor { 'sahara::install::end': }
  -> anchor { 'sahara::config::begin': }
  -> Sahara_config<||>
  ~> anchor { 'sahara::config::end': }
  -> anchor { 'sahara::db::begin': }
  -> anchor { 'sahara::db::end': }
  ~> anchor { 'sahara::dbsync::begin': }
  -> anchor { 'sahara::dbsync::end': }
  ~> anchor { 'sahara::service::begin': }
  ~> Service<| tag == 'sahara-service' |>
  ~> anchor { 'sahara::service::end': }

  # policy config should occur in the config block also.
  Anchor['sahara::config::begin']
  -> Openstacklib::Policy::Base<||>
  ~> Anchor['sahara::config::end']

  # all db settings should be applied and all packages should be installed
  # before dbsync starts
  Oslo::Db<||> -> Anchor['sahara::dbsync::begin']

  # Installation or config changes will always restart services.
  Anchor['sahara::install::end'] ~> Anchor['sahara::service::begin']
  Anchor['sahara::config::end']  ~> Anchor['sahara::service::begin']
}
