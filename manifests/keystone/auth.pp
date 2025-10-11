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
# [*roles*]
#   (Optional) List of roles assigned to neutron user.
#   Defaults to ['admin', 'service']
#
# [*system_scope*]
#   (Optional) Scope for system operations.
#   Defaults to 'all'
#
# [*system_roles*]
#   (Optional) List of system roles assigned to neutron user.
#   Defaults to []
#
# [*configure_endpoint*]
#   (Optional) Should mistral endpoint be configured?
#   Defaults to true.
#
# [*configure_user*]
#   (Optional) Should the service user be configured?
#   Defaults to true.
#
# [*configure_user_role*]
#   (Optional) Whether to configure the admin role for the service user.
#   Defaults to true
#
# [*configure_service*]
#   (Optional) Should mistral service be configured?
#   Defaults to true.
#
# [*service_type*]
#   (Optional) Type of service.
#   Defaults to 'workflowv2'.
#
# [*public_url*]
#   (Optional) The endpoint's public url.
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
# [*service_description*]
#   (Optional) Description for keystone service.
#   Defaults to 'Openstack workflow Service'.

class mistral::keystone::auth (
  String[1] $password,
  String[1] $email                        = 'mistral@localhost',
  String[1] $auth_name                    = 'mistral',
  String[1] $service_name                 = 'mistral',
  String[1] $service_type                 = 'workflowv2',
  Keystone::PublicEndpointUrl $public_url = 'http://127.0.0.1:8989/v2',
  Keystone::EndpointUrl $admin_url        = 'http://127.0.0.1:8989/v2',
  Keystone::EndpointUrl $internal_url     = 'http://127.0.0.1:8989/v2',
  String[1] $region                       = 'RegionOne',
  String[1] $tenant                       = 'services',
  Array[String[1]] $roles                 = ['admin', 'service'],
  String[1] $system_scope                 = 'all',
  Array[String[1]] $system_roles          = [],
  Boolean $configure_endpoint             = true,
  Boolean $configure_user                 = true,
  Boolean $configure_user_role            = true,
  Boolean $configure_service              = true,
  String[1] $service_description          = 'OpenStack Workflow Service',
) {
  include mistral::deps

  Keystone::Resource::Service_identity['mistral'] -> Anchor['mistral::service::end']

  keystone::resource::service_identity { 'mistral':
    configure_user      => $configure_user,
    configure_user_role => $configure_user_role,
    configure_endpoint  => $configure_endpoint,
    configure_service   => $configure_service,
    service_type        => $service_type,
    service_description => $service_description,
    service_name        => $service_name,
    region              => $region,
    auth_name           => $auth_name,
    password            => $password,
    email               => $email,
    tenant              => $tenant,
    roles               => $roles,
    system_scope        => $system_scope,
    system_roles        => $system_roles,
    public_url          => $public_url,
    admin_url           => $admin_url,
    internal_url        => $internal_url,
  }
}
