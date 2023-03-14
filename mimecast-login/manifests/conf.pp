#
class mimecast_login::conf (
$keyfile       = downcase("wildcard.login-${::mc_grid}.key"),
$pemfile       = downcase("wildcard.login-${::mc_grid}.pem"),
$pki_dir       = '/etc/pki/reverse-proxy',
$nginx_logdir  = '/usr/local/mimecast/nginx/logs',
$nginx_confdir = hiera('nginx::conf_dir','/etc/nginx'),
$nginx_service = hiera('nginx::service_name','nginx'),
$publicdomain = "${::mc_publicdomain}",
) {

# SSL CERTIFICATE SECTION
  # *.domain.tld - mimecast.com in prod
  ## for grids where mc_publicdomain is all set up
  $publicdomain_certificate = hiera(regsubst("wildcard.${::mc_publicdomain}", '\.', '_', 'G'))
  file { "/etc/pki/reverse-proxy/wildcard.${::mc_publicdomain}.pem":
    ensure  => present,
    owner   => root,
    group   => root,
    replace => true,
    mode    => '0400',
    content => $publicdomain_certificate['crt']
  }
  file { "/etc/pki/reverse-proxy/wildcard.${::mc_publicdomain}.key":
    ensure  => present,
    owner   => root,
    group   => root,
    replace => true,
    mode    => '0400',
    content => $publicdomain_certificate['key']
  }
  ## Jersey needs both mimecast.com (covered below) and mimecast-offshore.com (covered above) 
  if $::mc_grid == 'Jersey'
  {
    $onshorecert = hiera('wildcard_mimecast_com')
    file { '/etc/pki/reverse-proxy/wildcard.mimecast.com.pem':
        ensure  => present,
        owner   => root,
        group   => root,
        replace => true,
        mode    => '0400',
        content => $onshorecert['crt'],
    }
    file { '/etc/pki/reverse-proxy/wildcard.mimecast.com.key':
        ensure  => present,
        owner   => root,
        group   => root,
        replace => true,
        mode    => '0400',
        content => $onshorecert['key'],
    }
    include mimecast_login::branded
  }
  # *.login.domain.tld
  ## mc_publicsector is mimecast-offshore.com in Jersey, as of 
  ## 20210501 the login-us.mimecast.com certificate has a subjAltName 
  ## for mimecast-offshore.com login hosts. As such, we hard-code 'mimecast.com' instead of using mc_publicdomain

  $hieracert = hiera(regsubst("wildcard.login.${::mc_publicdomain}", '\.', '_', 'G'))
  $namecert = "wildcard.login.${::mc_publicdomain}"
  include mimecast_login::relayservice

  file { "${pki_dir}/${namecert}.key":
        ensure  => present,
        owner   => root,
        group   => root,
        replace => true,
        mode    => '0400',
        content => $hieracert['key'],
  }
  file { "${pki_dir}/${namecert}.pem":
        ensure  => present,
        owner   => root,
        group   => root,
        replace => true,
        mode    => '0444',
        content => $hieracert['crt'],
  }
  file { '/etc/pki/reverse-proxy/dhparam4096.pem':
    ensure  => present,
    source  => 'puppet:///modules/mimecast_login/ssl/dhparam4096.pem',
    replace => true,
    mode    => '0644',
    owner   => root,
    group   => root,
  }
  #END SSL CERTIFICATE SECTION
  #NGINX CONF
  # write /etc/nginx/conf.d/reverse_proxy.conf

  if $::mc_alpha == 'true' or $::mc_alpha == true {
    file { "${nginx_confdir}/conf.d/reverse_proxy.conf":
      ensure  => present,
      content => template('mimecast_login/nginx/reverse_proxy.alpha.erb'),
      replace => true,
      notify  => Exec['refresh_nginx'],
    }
  }
  else
  {
    file { "${nginx_confdir}/conf.d/reverse_proxy.conf":
      ensure  => present,
      content => template("mimecast_login/nginx/reverse_proxy.${::mc_grid}.erb"),
      replace => true,
      notify  => Exec['refresh_nginx'],
    }
  }
  exec { 'refresh_nginx':
    command     => "/usr/bin/systemctl reload ${nginx_service}",
    refreshonly => true,
  }
  #END NGINX CONF
  # MISC
  if $::mc_grid =~ /^(DEV|QA)$/
  {
    class { '::mimecast_login::docroot':
      base_dir   => '/www',
      vhost_fqdn => 'mta-sts.mimecast.com',
      htdocs     => 'htdocs',
    }
  }
  if $::mc_alpha == 'true' or $::mc_alpha == true {
    class { '::mimecast_login::docroot':
      base_dir   => '/www',
      vhost_fqdn => 'mta-sts.mimecast.com',
      htdocs     => 'htdocs',
    }
    file { '/www/mta-sts.mimecast.com/htdocs/.well-known':
      ensure => directory,
      mode   => '0755',
      owner  => 'nginx',
      group  => 'nginx',
    }
    file { '/www/mta-sts.mimecast.com/htdocs/.well-known/mta-sts.txt':
      ensure => present,
      source => 'puppet:///modules/mimecast_login/mta-sts.txt',
      mode   => '0644',
      owner  => 'nginx',
      group  => 'nginx',
    }
  }
}
