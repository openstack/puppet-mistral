# == Class: mistral::policy
#
# Configure the mistral policies
#
# === Parameters
#
# [*policies*]
#   (optional) Set of policies to configure for mistral
#   Example :
#     {
#       'mistral-context_is_admin' => {
#         'key' => 'context_is_admin',
#         'value' => 'true'
#       },
#       'mistral-default' => {
#         'key' => 'default',
#         'value' => 'rule:admin_or_owner'
#       }
#     }
#   Defaults to empty hash.
#
# [*policy_path*]
#   (optional) Path to the nova policy.json file
#   Defaults to /etc/mistral/policy.json
#
class mistral::policy (
  $policies    = {},
  $policy_path = '/etc/mistral/policy.json',
) {

  include ::mistral::deps
  include ::mistral::params

  validate_hash($policies)

  Openstacklib::Policy::Base {
    file_path  => $policy_path,
    file_user  => 'root',
    file_group => $::mistral::params::group,
  }

  create_resources('openstacklib::policy::base', $policies)

  oslo::policy { 'mistral_config': policy_file => $policy_path }

}
