# == Class: mistral::notifier
#
# Configure the mistral notifier
#
# === Parameters
#
# [*type*]
#   Type of notifier. Use local to run the notifier within the
#   engine server. Use remote if the notifier is launched as
#   a separate server to process events.
#   (string value)
#   Defaults to $::os_service_default.
# [*host*]
#   Name of the notifier node. This can be an opaque
#   identifier. It is not necessarily a hostname,
#   FQDN, or IP address.
#   (string value)
#   Defaults to $::os_service_default.
# [*topic*]
#   The message topic that the notifier server listens on.
#   (string value)
#   Defaults to $::os_service_default.
# [*notify_publishers*]
#   List of publishers to publish notification.
#   Note: This maps to the mistral config option `notify` but this is reserved
#   in Puppet.
#   (list of dicts)
#   Defaults to $::os_service_default.

class mistral::notifier(
  $type               = $::os_service_default,
  $host               = $::os_service_default,
  $topic              = $::os_service_default,
  $notify_publishers  = $::os_service_default,
) {

  include ::mistral::deps
  include ::mistral::params

  mistral_config {
    'notifier/type':             value => $type;
    'notifier/host':             value => $host;
    'notifier/topic':            value => $topic;
    'notifier/notify':           value => $notify_publishers;
  }
}
