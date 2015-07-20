# == Class: sahara::config
#
# This class is used to manage arbitrary Sahara configurations.
#
# === Parameters
#
# [*sahara_config*]
#   (optional) Allow configuration of arbitrary Sahara configurations.
#   The value is an hash of sahara_config resources. Example:
#   { 'DEFAULT/foo' => { value => 'fooValue'},
#     'DEFAULT/bar' => { value => 'barValue'}
#   }
#   In yaml format, Example:
#   sahara_config:
#     DEFAULT/foo:
#       value: fooValue
#     DEFAULT/bar:
#       value: barValue
#
#   NOTE: The configuration MUST NOT be already handled by this module
#   or Puppet catalog compilation will fail with duplicate resources.
#
class sahara::config (
  $sahara_config        = {},
) {

  validate_hash($sahara_config)

  create_resources('sahara_config', $sahara_config)
}
