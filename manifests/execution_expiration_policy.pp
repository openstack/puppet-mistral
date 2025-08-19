# == Class: mistral::execution_expiration_policy
#
# Configure the mistral execution_expiration_policy
#
# === Parameters
#
# [*evaluation_interval*]
#   (Optional) How often will the executions be evaluated (in minutes).
#   Defaults to $facts['os_service_default'].
#
# [*older_than*]
#   (Optional) Evaluate from which time remove executions in minutes.
#   Note that only final state execution will remove (SUCCESS/ERROR).
#   Defaults to $facts['os_service_default'].
#
# [*max_finished_executions*]
#   (Optional) The maximum number of finished workflow executions to be stored.
#   Defaults to $facts['os_service_default'].
#
# [*batch_size*]
#   (Optional) Size of batch of expired executions to be deleted.
#   Defaults to $facts['os_service_default'].
#
# [*ignored_states*]
#   (Optional) The states that the expiration policy will filter out and will
#   not delete.
#   Defaults to $facts['os_service_default'].
#
class mistral::execution_expiration_policy (
  $evaluation_interval     = $facts['os_service_default'],
  $older_than              = $facts['os_service_default'],
  $max_finished_executions = $facts['os_service_default'],
  $batch_size              = $facts['os_service_default'],
  $ignored_states          = $facts['os_service_default'],
) {
  include mistral::deps
  include mistral::params

  mistral_config {
    'execution_expiration_policy/evaluation_interval':     value => $evaluation_interval;
    'execution_expiration_policy/older_than':              value => $older_than;
    'execution_expiration_policy/max_finished_executions': value => $max_finished_executions;
    'execution_expiration_policy/batch_size':              value => $batch_size;
    'execution_expiration_policy/ignored_states':          value => join(any2array($ignored_states), ',');
  }
}
