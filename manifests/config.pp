# == Class: mistral::config
#
# This class is used to manage arbitrary mistral configurations.
#
# === Parameters
#
# [*mistral_config*]
#   (optional) Allow configuration of arbitrary mistral configurations.
#   The value is an hash of mistral_config resources. Example:
#   { 'DEFAULT/foo' => { value => 'fooValue'},
#     'DEFAULT/bar' => { value => 'barValue'}
#   }
#   In yaml format, Example:
#   mistral_config:
#     DEFAULT/foo:
#       value: fooValue
#     DEFAULT/bar:
#       value: barValue
#
#   NOTE: The configuration MUST NOT be already handled by this module
#   or Puppet catalog compilation will fail with duplicate resources.
#
class mistral::config (
  Hash $mistral_config = {},
) {

  include mistral::deps

  create_resources('mistral_config', $mistral_config)
}
