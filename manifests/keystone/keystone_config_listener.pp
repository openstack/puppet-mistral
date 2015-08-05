# == Class: mistral::keystone::keystone_config_listener
#
# Listener for the keystone. this class will call mistral::keystone::auth  when keystone will be up
#
# === Parameters
#
#[*listening_service*]
#   (required) The name that will be called from keystone
#
# [*password*]
#   (required) Password for mistral user.
#
# [*auth_name*]
#   Username for mistral service. Defaults to 'mistral'.
#
#
# [*email*]
#   Email for mistral user. Defaults to 'mistral@localhost'.
#
# [*tenant*]
#   Tenant for mistral user. Defaults to 'services'.
#
# [*configure_endpoint*]
#   Should mistral endpoint be configured? Defaults to 'true'.
#
# [*configure_user*]
#   (Optional) Should the service user be configured?
#   Defaults to 'true'.
#
# [*service_type*]
#   Type of service. Defaults to 'workflow'.
#
# [*public_protocol*]
#   Protocol for public endpoint. Defaults to 'http'.
#
# [*public_address*]
#   Public address for endpoint. Defaults to '127.0.0.1'.
#
# [*admin_protocol*]
#   Protocol for admin endpoint. Defaults to 'http'.
#
# [*admin_address*]
#   Admin address for endpoint. Defaults to '127.0.0.1'.
#
# [*internal_protocol*]
#   Protocol for internal endpoint. Defaults to 'http'.
#
# [*internal_address*]
#   Internal address for endpoint. Defaults to '127.0.0.1'.
#
# [*port*]
#   Port for endpoint. Defaults to '8989'.
#
# [*public_port*]
#   Port for public endpoint. Defaults to $port.
#
# [*region*]
#   Region for endpoint. Defaults to 'RegionOne'.
#
# [*service_name*]
#   (optional) Name of the service.
#   Defaults to the value of auth_name.
#
# [*configure_service*]
#   Should mistral service be configured? Defaults to 'true'.
#
# [*unique_name*]
#   (optional) This name is for mistral in HA
#     Defaults is '${::fqdn}_${auth_name}'
#
# [*service_description*]
#  (optional) This description os the service
#   Defaults is 'Openstack workflow Service'
#
define mistral::keystone::keystone_config_listener(
  $listening_service,
  $password             = false,
  $email                = 'mistral@localhost',
  $auth_name            = 'mistral',
  $service_name         = undef,
  $service_type         = 'workflow',
  $service_description  = 'Openstack workflow Service',
  $public_address       = '127.0.0.1',
  $admin_address        = '127.0.0.1',
  $internal_address     = '127.0.0.1',
  $port                 = '8989',
  $region               = 'RegionOne',
  $tenant               = 'services',
  $public_protocol      = 'http',
  $admin_protocol       = 'http',
  $internal_protocol    = 'http',
  $configure_endpoint   = true,
  $configure_service    = true,
  $configure_user       = true,
  $unique_name          = "${::fqdn}_${auth_name}"
){

  if ! defined(mistral::keystone::auth[$unique_name]){
    mistral::keystone::auth { $unique_name:
      password           => $password,
      email              => $email,
      auth_name          => $auth_name,
      service_name       => $service_name,
      service_type       => $service_type,
      public_address     => $public_address,
      admin_address      => $admin_address,
      internal_address   => $internal_address,
      port               => $port,
      region             => $region,
      tenant             => $tenant,
      public_protocol    => $public_protocol,
      admin_protocol     => $admin_protocol,
      internal_protocol  => $internal_protocol,
      configure_endpoint => $configure_endpoint,
      configure_service  => $configure_service,
      configure_user     => $configure_user,
      unique_name        => $unique_name
    }
  }
}
