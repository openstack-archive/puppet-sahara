# == Class: sahara::healthcheck
#
# Configure oslo_middleware options in healthcheck section
#
# == Params
#
# [*detailed*]
#   (Optional) Show more detailed information as part of the response.
#   Defaults to $facts['os_service_default']
#
# [*backends*]
#   (Optional) Additional backends that can perform health checks and report
#   that information back as part of a request.
#   Defaults to $facts['os_service_default']
#
# [*disable_by_file_path*]
#   (Optional) Check the presense of a file to determine if an application
#   is running on a port.
#   Defaults to $facts['os_service_default']
#
# [*disable_by_file_paths*]
#   (Optional) Check the presense of a file to determine if an application
#   is running on a port. Expects a "port:path" list of strings.
#   Defaults to $facts['os_service_default']
#
class sahara::healthcheck (
  $detailed              = $facts['os_service_default'],
  $backends              = $facts['os_service_default'],
  $disable_by_file_path  = $facts['os_service_default'],
  $disable_by_file_paths = $facts['os_service_default'],
) {

  include sahara::deps

  oslo::healthcheck { 'sahara_config':
    detailed              => $detailed,
    backends              => $backends,
    disable_by_file_path  => $disable_by_file_path,
    disable_by_file_paths => $disable_by_file_paths,
  }
}
