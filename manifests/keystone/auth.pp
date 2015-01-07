# == Class: sahara::keystone::auth
#
# Configures sahara service and endpoint in Keystone.
#
# === Parameters
#
# [*password*]
#   (required) Password for Sahara user.
#
# [*service_name*]
#   (Optional) Name of the service.
#   Defaults to the value of auth_name.
#
# [*auth_name*]
#   (Optional) Username for sahara service.
#   Defaults to 'sahara'.
#
# [*email*]
#   (Optional) Email for Sahara user.
#   Defaults to 'sahara@localhost'.
#
# [*tenant*]
#   (Optional) Tenant for Sahara user.
#   Defaults to 'services'.
#
# [*configure_endpoint*]
#   (Optional) Should Sahara endpoint be configured?
#   Defaults to 'true'.
#
# [*service_type*]
#   (Optional) Type of service.
#   Defaults to 'data-processing'.
#
# [*service_description*]
#   (Optional) Description of service.
#   Defaults to 'Sahara Data Processing'.
#
# [*region*]
#   (Optional) Region for endpoint.
#   Defaults to 'RegionOne'.
#
# [*public_protocol*]
#   (Optional) Protocol for public endpoint.
#   Defaults to 'http'.
#
# [*admin_protocol*]
#   (Optional) Protocol for admin endpoint.
#   Defaults to 'http'.
#
# [*internal_protocol*]
#   (Optional) Protocol for internal endpoint.
#   Defaults to 'http'.
#
# [*public_address*]
#   (Optional) Public address for endpoint.
#   Defaults to '127.0.0.1'.
#
# [*admin_address*]
#   (Optional) Admin address for endpoint.
#   Defaults to '127.0.0.1'.
#
# [*internal_address*]
#   (Optional) Internal address for endpoint.
#   Defaults to '127.0.0.1'.
#
# [*port*]
#   (Optional) Port for endpoint.
#   Defaults to '8386'.
#
# [*public_port*]
#   Port for public endpoint. Defaults to $port.
#
# [*version*]
#   (Optional) Version of API to use.
#   Defaults to 'v1.1'.
#
class sahara::keystone::auth(
  $password,
  $service_name        = undef,
  $auth_name           = 'sahara',
  $email               = 'sahara@localhost',
  $tenant              = 'services',
  $service_type        = 'data-processing',
  $service_description = 'Sahara Data Processing',
  $configure_endpoint  = true,
  $region              = 'RegionOne',
  $public_protocol     = 'http',
  $admin_protocol      = 'http',
  $internal_protocol   = 'http',
  $public_address      = '127.0.0.1',
  $admin_address       = '127.0.0.1',
  $internal_address    = '127.0.0.1',
  $port                = '8386',
  $public_port         = undef,
  $version             = 'v1.1',
) {

  if $service_name == undef {
    $real_service_name = $auth_name
  } else {
    $real_service_name = $service_name
  }

  if ! $public_port {
    $real_public_port = $port
  } else {
    $real_public_port = $public_port
  }


  keystone::resource::service_identity { $real_service_name:
    configure_user      => true,
    configure_user_role => true,
    configure_endpoint  => $configure_endpoint,
    service_type        => $service_type,
    service_description => $service_description,
    region              => $region,
    password            => $password,
    email               => $email,
    tenant              => $tenant,
    public_url          => "${public_protocol}://${public_address}:${real_public_port}/${version}/%(tenant_id)s",
    admin_url           => "${admin_protocol}://${admin_address}:${port}/${version}/%(tenant_id)s",
    internal_url        => "${internal_protocol}://${internal_address}:${port}/${version}/%(tenant_id)s",
  }
}
