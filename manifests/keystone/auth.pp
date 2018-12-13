# == Class: mistral::keystone::auth
#
# Configures mistral user, service and endpoint in Keystone.
#
# === Parameters
#
# [*password*]
#   (Required) Password for mistral user.
#
# [*auth_name*]
#   (Optional) Username for mistral service.
#   Defaults to 'mistral'.
#
# [*email*]
#   (Optional) Email for mistral user.
#   Defaults to 'mistral@localhost'.
#
# [*tenant*]
#   (Optional) Tenant for mistral user.
#   Defaults to 'services'.
#
# [*configure_endpoint*]
#   (Optional) Should mistral endpoint be configured?
#   Defaults to true.
#
# [*configure_user*]
#   (Optional) Should the service user be configured?
#   Defaults to true.
#
# [*service_type*]
#   (Optional) Type of service.
#   Defaults to 'workflowv2'.
#
# [*public_url*]
#   (0ptional) The endpoint's public url.
#   Defaults to 'http://127.0.0.1:8989:/v2'
#
# [*internal_url*]
#   (Optional) The endpoint's internal url.
#   Defaults to 'http://127.0.0.1:8989/v2'
#
# [*admin_url*]
#   (Optional) The endpoint's admin url.
#   Defaults to 'http://127.0.0.1:8989/v2'
#
# [*region*]
#   (Optional) Region for endpoint.
#   Defaults to 'RegionOne'.
#
# [*service_name*]
#   (Optional) Name of the service.
#   Defaults to 'mistral'.
#
# [*configure_service*]
#   (Optional) Should mistral service be configured?
#   Defaults to true.
#
# [*service_description*]
#   (Optional) Description for keystone service.
#   Defaults to 'Openstack workflow Service'.

# [*configure_user_role*]
#   (Optional) Whether to configure the admin role for the service user.
#   Defaults to true
#
class mistral::keystone::auth(
  $password,
  $email                  = 'mistral@localhost',
  $auth_name              = 'mistral',
  $service_name           = 'mistral',
  $service_type           = 'workflowv2',
  $public_url             = 'http://127.0.0.1:8989/v2',
  $admin_url              = 'http://127.0.0.1:8989/v2',
  $internal_url           = 'http://127.0.0.1:8989/v2',
  $region                 = 'RegionOne',
  $tenant                 = 'services',
  $configure_endpoint     = true,
  $configure_service      = true,
  $configure_user         = true,
  $configure_user_role    = true,
  $service_description    = 'OpenStack Workflow Service',
) {

  include ::mistral::deps

  validate_string($password)

  keystone::resource::service_identity { 'mistral':
    configure_user      => $configure_user,
    configure_user_role => $configure_user_role,
    configure_endpoint  => $configure_endpoint,
    service_type        => $service_type,
    service_description => $service_description,
    service_name        => $service_name,
    region              => $region,
    auth_name           => $auth_name,
    password            => $password,
    email               => $email,
    tenant              => $tenant,
    public_url          => $public_url,
    admin_url           => $admin_url,
    internal_url        => $internal_url,
  }
}
