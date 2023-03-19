#
class adminconsole {
  Class['mimecast_tomcat'] -> Class['adminconsole']

  $jmx_ldap_ensure = $::mc_grid ? {
    'DEV'    => present,
    'QA'     => present,
    'LT'     => present,
    default  => absent
  }

  $adminconsole_env_path = $::mc_grid ? {
    'DEV'    => 'puppet:///modules/adminconsole/scripts/DEV',
    'QA'     => 'puppet:///modules/adminconsole/scripts/QA',
    'LT'     => 'puppet:///modules/adminconsole/scripts/LT',
    default  => absent
  }

  $mcwebapp_env_path = $::mc_grid ? {
    'DEV'    => 'puppet:///modules/mcwebapp/scripts/DEV',
    'QA'     => 'puppet:///modules/mcwebapp/scripts/QA',
    'LT'     => 'puppet:///modules/mcwebapp/scripts/LT',
    default  => absent
  }

  if ( $::mc_grid =~ /DEV|QA|LT/) {
    file { '/usr/local/tomcat/cfg/adcon-web-ui.json':
      ensure  => $jmx_ldap_ensure,
      source  => ["${adminconsole_env_path}/${::hostname}/adcon-web-ui.json",
      "${adminconsole_env_path}/adcon-web-ui.json"],
      owner   => 'mcuser',
      group   => 'mcuser',
      mode    => '0644',
      notify  => Service['tomcat-adminconsole'],
      replace => true,
    }
    file { '/usr/local/mimecast/.keystore':
      ensure => link,
      target => '/usr/local/mimecast/mimecast.lan_keystore',
      owner  => 'mcuser',
      group  => 'mcuser',
      mode   => '0777',
    }
  } else {
    file { '/usr/local/mimecast/.keystore':
      ensure => 'link',
      target => '/usr/local/mimecast/keystore',
    }
  }

  file { '/usr/local/mimecast/log4j.xml':
    ensure  => file,
    source  => [
      "${adminconsole_env_path}/${::hostname}/log4j.xml",
      "${adminconsole_env_path}/log4j.xml",
      'puppet:///modules/adminconsole/scripts/log4j.xml',
    ],
    owner   => 'mcuser',
    group   => 'mcuser',
    mode    => '0644',
    replace => true,
  }

  file { '/usr/local/tomcat/bin/catalina.sh':
    ensure  => file,
    source  => [
      "${adminconsole_env_path}/${::hostname}/catalina.sh",
      "puppet:///modules/adminconsole/scripts/${::mc_servertype}/catalina.sh",
      "${adminconsole_env_path}/catalina.sh",
      'puppet:///modules/adminconsole/scripts/catalina.sh',
    ],
    owner   => 'mcuser',
    group   => 'mcuser',
    mode    => '0755',
    replace => true,
  }
  # 'log' and 'logs'? seriously? *sigh*
  file { '/usr/local/tomcat/log':
    ensure => directory,
    owner  => 'mcuser',
    group  => 'mcuser',
    force  => true,
  }

  file { '/usr/local/tomcat/cfg':
    ensure => directory,
    owner  => 'mcuser',
    group  => 'mcuser',
    force  => true,
    before => File['/usr/local/tomcat/cfg/localproperties.json','/usr/local/tomcat/cfg/server.json'],
  }

  file { '/usr/local/tomcat/work':
    ensure => directory,
    owner  => 'mcuser',
    group  => 'mcuser',
    force  => true,
  }

  file { '/usr/local/tomcat/webapps/mimecast/':
    ensure  => directory,
    owner   => 'mcuser',
    group   => 'mcuser',
    recurse => true,
  }

  file { '/usr/local/tomcat/webapps/mimecast/resources/':
    ensure  => directory,
    owner   => 'mcuser',
    recurse => true,
    require => File['/usr/local/tomcat/webapps/mimecast/'],
  }

  file { '/usr/local/tomcat/webapps/mimecast/resources/images/':
    ensure  => directory,
    owner   => 'mcuser',
    recurse => true,
    require => File['/usr/local/tomcat/webapps/mimecast/resources/'],
  }

  file { '/usr/local/tomcat/webapps/mimecast/resources/images/notifications':
    ensure  => directory,
    owner   => 'mcuser',
    recurse => true,
    require => File['/usr/local/tomcat/webapps/mimecast/resources/images/']
  }

  file { '/usr/local/tomcat/webapps/mimecast/resources/images/notifications/powered-mimecast-logo-278x28.png':
    ensure  => file,
    source  => [
      'puppet:///modules/adminconsole/scripts/powered-mimecast-logo-278x28.png',
    ],
    owner   => 'mcuser',
    group   => 'mcuser',
    mode    => '0644',
    require => File['/usr/local/tomcat/webapps/mimecast/resources/images/notifications'],
  }

  file { '/usr/local/tomcat/webapps/mimecast/resources/images/notifications/mimecast-logo-81x14.png':
    ensure  => file,
    source  => [
      'puppet:///modules/adminconsole/scripts/mimecast-logo-81x14.png',
    ],
    owner   => 'mcuser',
    group   => 'mcuser',
    mode    => '0644',
    require => File['/usr/local/tomcat/webapps/mimecast/resources/images/notifications'],
  }

  file { '/usr/local/tomcat/webapps/mimecast/resources/images/notifications/placeholder-pixel.png':
    ensure  => file,
    source  => [
      'puppet:///modules/adminconsole/scripts/placeholder-pixel.png',
    ],
    owner   => 'mcuser',
    group   => 'mcuser',
    mode    => '0644',
    require => File['/usr/local/tomcat/webapps/mimecast/resources/images/notifications'],
  }

  file { '/usr/local/tomcat/webapps/ROOT':
    ensure => directory,
    owner  => 'mcuser',
    group  => 'mcuser',
    force  => true,
    before => File['/usr/local/tomcat/webapps/ROOT/index.jsp'],
  }

  file { '/usr/local/tomcat/webapps/ROOT/index.jsp':
    ensure  => file,
    source  => 'puppet:///modules/adminconsole/scripts/index.jsp',
    owner   => 'mcuser',
    group   => 'mcuser',
    mode    => '0644',
    replace => true,
  }

  file { '/usr/local/tomcat/cfg/jmx_ldap.config':
    ensure  => $jmx_ldap_ensure,
    source  => [
      "${mcwebapp_env_path}/${::hostname}/jmx_ldap.config",
      "${mcwebapp_env_path}/jmx_ldap.config",
      'puppet:///modules/mcwebapp/scripts/jmx_ldap.config',
    ],
    owner   => 'mcuser',
    group   => 'mcuser',
    mode    => '0644',
    replace => true,
  }

  file { '/usr/local/tomcat/cfg/jmxremote.access':
    ensure  => $jmx_ldap_ensure,
    source  => [
      "${mcwebapp_env_path}/${::hostname}/jmxremote.access",
      "${mcwebapp_env_path}/jmxremote.access",
      'puppet:///modules/mcwebapp/scripts/jmxremote.access',
    ],
    owner   => 'mcuser',
    group   => 'mcuser',
    mode    => '0644',
    replace => true
  }

  file { '/usr/local/tomcat/conf/server.xml':
    ensure  => file,
    source  => [
      "${adminconsole_env_path}/${::hostname}/server.xml",
      "${adminconsole_env_path}/server.xml",
      'puppet:///modules/adminconsole/scripts/server.xml',
    ],
    owner   => 'mcuser',
    group   => 'mcuser',
    mode    => '0644',
    replace => true,
  }

  file { '/usr/local/tomcat/cfg/localproperties.json':
    ensure  => file,
    source  => [
      "${adminconsole_env_path}/${::hostname}/localproperties.json",
      "${adminconsole_env_path}/localproperties.json",
      'puppet:///modules/adminconsole/scripts/localproperties.json'
    ],
    owner   => 'mcuser',
    group   => 'mcuser',
    mode    => '0644',
    replace => true,
    #    before  => Service['adminconsole-tomcat']
  }

  file { '/usr/local/tomcat/cfg/server.json':
    ensure  => file,
    content => template('adminconsole/server.json.erb'),
    owner   => 'mcuser',
    group   => 'mcuser',
    mode    => '0644',
    replace => true,
  }

  package { 'adminconsole':
    ensure => installed,
  }

  service { 'tomcat-adminconsole':
    ensure    => 'stopped',
    hasstatus => true,
    require   => Package['adminconsole'],
    subscribe => [
      File['/usr/local/tomcat/cfg/localproperties.json'],
      File['/usr/local/tomcat/bin/catalina.sh'],
      File['/usr/local/tomcat/cfg/server.json'],
    ],
  }

  file { '/etc/rc.d/init.d/tomcat-adminconsole':
    ensure  => file,
    source  => [
      "${adminconsole_env_path}/${::hostname}/tomcat-adminconsole",
      "${adminconsole_env_path}/tomcat-adminconsole",
      'puppet:///modules/adminconsole/scripts/tomcat-adminconsole',
    ],
    owner   => root,
    group   => root,
    mode    => '0755',
    replace => true,
    force   => false;
  }

  file { '/usr/local/tomcat/bin/setenv.sh':
    ensure => file,
    source => [
      "${adminconsole_env_path}/${::hostname}/setenv.sh",
      "${adminconsole_env_path}/setenv.sh",
      'puppet:///modules/adminconsole/scripts/setenv.sh',
    ],
    owner   => 'mcuser',
    group   => 'mcuser',
    mode    => '0755',
    replace => true,
    before  => Service['tomcat-adminconsole'],
    force   => true;
  }

  file { '/etc/init.d/adminconsole':
    ensure => 'link',
    target => '/etc/rc.d/init.d/tomcat-adminconsole',
  }

  logrotation::worker { 'adminconsole':
    service                 => ['adminconsole','adminconsole-catalina','adminconsole-access'],
    log_dir                 => ['/usr/local/tomcat/log','/usr/local/tomcat/logs','/usr/local/tomcat/logs'],
    log_pattern_to_compress => ['*.log','*.log','*.txt'],
    log_age_to_compress     => ['+7','+7','+7'],
    log_pattern_to_remove   => ['*.log.zst','*.log.zst','*.txt.zst'],
    log_age_to_remove       => ['+61','+61','+61'],
  }

  $mcms_user = hiera('postgres_users')

  file { '/usr/local/tomcat/debug':
    ensure => directory,
    owner  => 'mcuser',
    group  => 'mcuser';
  }

  file { '/usr/local/tomcat/cache':
    ensure => directory,
    owner  => 'mcuser',
    group  => 'mcuser';
  }

  file { '/usr/local/tomcat/debug/adcon-web-ui.json':
    content => template('adminconsole/adcon-web-ui.json.erb'),
    owner   => 'mcuser',
    group   => 'mcuser',
    mode    => '0644',
    notify  => Service['tomcat-adminconsole'],
    replace => true,
    require => File['/usr/local/tomcat/debug'],
  }
}
