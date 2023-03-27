#
class mimecast_web_container::package {
  if (( $::mc_grid == 'DEV' ) and ($::mc_servertype == 'webservice' or $::mc_servertype == 'adminweb_supervision')) {
    $packages = ['mimecast-portal', 'mimecast-large-files','mimecast-universal-login', 'mimecast-admin-console', 'mimecast-reviewer', 'mimecast-supervision']
  }
  elsif (( $::mc_grid == 'SND' ) and ($::mc_servertype == 'webservice' or $::mc_servertype == 'adminweb_supervision')) {
    $packages = ['mimecast-portal', 'mimecast-large-files','mimecast-universal-login', 'mimecast-admin-console', 'mimecast-reviewer']
  }
  elsif $::mc_grid == 'QA'  or  $::mc_grid == 'STG' {
    $packages = ['mimecast-portal', 'mimecast-large-files','mimecast-universal-login', 'mimecast-admin-console', 'mimecast-reviewer', 'mimecast-supervision']
  }
  elsif $::mc_grid == 'DEV' and $::mc_servertype == 'adcon' {
    $packages = ['adminconsole-integrated', 'mimecast-supervision']
  }
  elsif $::mc_servertype == 'webservice-alpha' {
    $packages = ['mimecast-portal', 'mimecast-large-files','mimecast-universal-login','mimecast-admin-console', 'mimecast-reviewer', 'mimecast-supervision']
  }
  elsif $::mc_servertype == 'webservice' {
    if ( $::mc_canary15 == 'true' ) {
      $packages = ['mimecast-portal', 'mimecast-large-files','mimecast-universal-login','mimecast-admin-console', 'mimecast-reviewer', 'mimecast-supervision']
    }
    else {
      $packages = ['mimecast-portal', 'mimecast-large-files','mimecast-universal-login','mimecast-admin-console', 'mimecast-reviewer', 'mimecast-supervision']
    }
  }
  elsif $::mc_servertype == 'adcon' and $::mc_alpha == 'true' {
    $packages = ['adminconsole-integrated']
  }
  elsif $::mc_servertype == 'adcon' {
    $packages = ['adminconsole-integrated']
  }
  # elsif $::mc_grid == 'STG' or $::mc_grid == 'SND' {
  #     $packages = [ 'mimecast-reviewer' ]
  # }
  package { 'mimecast-web-container': }
  -> package { $packages:
    ensure => 'present',
  }
  # SEOPS-2279 preview period has expired, purge from all grids
  package { 'mimecast-universal-login-preview':
    ensure => 'absent',
  }
}
