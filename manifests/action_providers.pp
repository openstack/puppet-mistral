# == Class: mistral::action_providers
#
# Configure the action_providers config section.
#
# === Parameters
#
# [*allowlist*]
#   (Optional) Allowlist with actions that is allowed to be
#   loaded, if empty all actions will be allowed.
#   Defaults to $facts['os_service_default']

# [*denylist*]
#   (Optional) Denylist with actions that is not allowed to
#   be loaded, allowlist takes precedence, if empty all actions
#   will be allowed.
#   Defaults to $facts['os_service_default']
#
class mistral::action_providers (
  $allowlist = $facts['os_service_default'],
  $denylist  = $facts['os_service_default'],
) {
  include mistral::deps

  mistral_config {
    'action_providers/allowlist': value => join(any2array($allowlist), ',');
    'action_providers/denylist':  value => join(any2array($denylist), ',');
  }
}
