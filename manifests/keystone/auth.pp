# == Class: sahara::keystone::auth
#
# Configures sahara service and endpoint in Keystone.
#
# === Parameters
#
# [*password*]
#   (Required) Password for Sahara user.
#
# [*service_name*]
#   (Optional) Name of the service.
#   Defaults to 'sahara'
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
#   Defaults to true.
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
# [*public_url*]
#   (Optional) The endpoint's public url.
#   This url should *not* contain any trailing '/'.
#   Defaults to 'http://127.0.0.1:8386'
#
# [*admin_url*]
#   (Optional) The endpoint's admin url.
#   This url should *not* contain any trailing '/'.
#   Defaults to 'http://127.0.0.1:8386'
#
# [*internal_url*]
#   (Optional) The endpoint's internal url.
#   This url should *not* contain any trailing '/'.
#   Defaults to 'http://127.0.0.1:8386'
#
# === Examples
#
#  class { 'sahara::keystone::auth':
#    password     => 'secret',
#    public_url   => 'https://10.0.0.10:8386',
#    internal_url => 'https://10.0.0.11:8386',
#    admin_url    => 'https://10.0.0.11:8386',
#  }
#
class sahara::keystone::auth(
  $password,
  $service_name        = 'sahara',
  $auth_name           = 'sahara',
  $email               = 'sahara@localhost',
  $tenant              = 'services',
  $service_type        = 'data-processing',
  $service_description = 'Sahara Data Processing',
  $configure_endpoint  = true,
  $region              = 'RegionOne',
  $public_url          = 'http://127.0.0.1:8386',
  $admin_url           = 'http://127.0.0.1:8386',
  $internal_url        = 'http://127.0.0.1:8386',
) {

  include ::sahara::deps

  keystone::resource::service_identity { 'sahara':
    configure_user      => true,
    configure_user_role => true,
    configure_endpoint  => $configure_endpoint,
    service_type        => $service_type,
    service_description => $service_description,
    service_name        => $service_name,
    auth_name           => $auth_name,
    region              => $region,
    password            => $password,
    email               => $email,
    tenant              => $tenant,
    public_url          => $public_url,
    admin_url           => $admin_url,
    internal_url        => $internal_url,
  }
}
