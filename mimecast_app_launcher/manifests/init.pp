#
class mimecast_app_launcher {

  class { "::${module_name}::package": } ->
  class { "::${module_name}::config":  } ->
  class { "::${module_name}::service": }

}
