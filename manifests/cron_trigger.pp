# == Class: mistral::cron_trigger
#
# Configure the mistral cron_trigger
#
# === Parameters
#
# [*enabled*]
#   (Optional) If this value is set to False then the subsystem of
#   cron triggers is disabled.
#   Disabling cron triggers increases system performance.
#   (boolean value)
#   Defaults to $::os_service_default.
#
# [*execution_interval*]
#   (Optional) This setting defines how frequently Mistral checks for cron
#   triggers that need execution. By default this is every second
#   which can lead to high system load. Increasing the number will
#   reduce the load but also limit the minimum freqency. For
#   example, a cron trigger can be configured to run every second
#   but if the execution_interval is set to 60, it will only run
#   once per minute.
#   (integer value)
#   Defaults to $::os_service_default.
#
#
class mistral::cron_trigger (
  $enabled            = $::os_service_default,
  $execution_interval = $::os_service_default,
) {

  include ::mistral::deps
  include ::mistral::params

  mistral_config {
    'cron_trigger/enabled':             value => $enabled;
    'cron_trigger/execution_interval':  value => $execution_interval;
  }
}
