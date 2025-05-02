# == Class: mistral::legacy_action_providers
#
# Configure the legacy_action_providers config section.
#
# === Parameters
#
# [*load_action_plugins*]
#   (Optional) Enables loading actions configured in the
#   entry point "mistral.actions".
#   Defaults to $facts['os_service_default']
#
# [*load_action_generators*]
#   (Optional) Enables loading actions from action generators
#   configured in the entry point "mistral.generators".
#   Defaults to $facts['os_service_default']
#
# [*only_builtin_actions*]
#   (Optional) If True, then the legacy action provider loads
#   only the actions delivered by the Mistral project out of
#   the box plugged in with the entry point "mistral.actions".
#   This property is needed mostly for testing.'
#   Defaults to $facts['os_service_default']
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
class mistral::legacy_action_providers (
  $load_action_plugins    = $facts['os_service_default'],
  $load_action_generators = $facts['os_service_default'],
  $only_builtin_actions   = $facts['os_service_default'],
  $allowlist              = $facts['os_service_default'],
  $denylist               = $facts['os_service_default'],
) {

  mistral_config {
    'legacy_action_providers/load_action_plugins':    value => $load_action_plugins;
    'legacy_action_providers/load_action_generators': value => $load_action_generators;
    'legacy_action_providers/only_builtin_actions':   value => $only_builtin_actions;
    'legacy_action_providers/allowlist':              value => join(any2array($allowlist), ',');
    'legacy_action_providers/denylist':               value => join(any2array($denylist), ',');
  }
}
