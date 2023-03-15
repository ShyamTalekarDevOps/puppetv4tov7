# 
class mimecast_sea_star_server_toolkit {

  class { '::mimecast_sea_star_server_toolkit::config':  }
  class { '::mimecast_sea_star_server_toolkit::apps_config':  }
  -> class { '::mimecast_sea_star_server_toolkit::package': }
  class { '::mimecast_sea_star_server_toolkit::service': }

}
