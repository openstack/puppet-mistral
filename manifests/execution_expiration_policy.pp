# == Class: mistral::execution_expiration_policy
#
# Configure the mistral execution_expiration_policy
#
# === Parameters
#
# [*evaluation_interval*]
#   (Optional) How often will the executions be evaluated (in minutes).
#   Defaults to $::os_service_default.
#
# [*older_than*]
#   (Optional) Evaluate from which time remove executions in minutes.
#   Note that only final state execution will remove (SUCCESS/ERROR).
#   Defaults to $::os_service_default.
#
# [*max_finished_executions*]
#   (Optional) THe maximum nuber of finised workflow executions to be stored.
#   Defaults to $::os_service_default.
#
# [*batch_size*]
#   (Optional) Size of batch of expired executions to be deleted.
#   Defaults to $::os_service_default.
#
# [*ignored_states*]
#   (Optional) THe states that the expiration policy will filter out and will
#   not delete.
#   Defaults to $::os_service_default.
#
class mistral::execution_expiration_policy (
  $evaluation_interval     = $::os_service_default,
  $older_than              = $::os_service_default,
  $max_finished_executions = $::os_service_default,
  $batch_size              = $::os_service_default,
  $ignored_states          = $::os_service_default,
) {

  include mistral::deps
  include mistral::params

  $evaluation_interval_real = pick($::mistral::engine::evaluation_interval, $evaluation_interval)
  $older_than_real = pick($::mistral::engine::older_than, $older_than)

  mistral_config {
    'execution_expiration_policy/evaluation_interval':     value => $evaluation_interval_real;
    'execution_expiration_policy/older_than':              value => $older_than_real;
    'execution_expiration_policy/max_finished_executions': value => $max_finished_executions;
    'execution_expiration_policy/batch_size':              value => $batch_size;
    'execution_expiration_policy/ignored_states':          value => join(any2array($ignored_states), ',');
  }
}
