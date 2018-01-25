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
#
class mistral::cron_trigger (
  $enabled            = $::os_service_default,
) {

  include ::mistral::deps
  include ::mistral::params

  mistral_config {
    'cron_trigger/enabled':        value => $enabled;
  }
}
