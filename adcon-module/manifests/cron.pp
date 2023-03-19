#
class adminconsole::cron {
  file { '/usr/local/scripts/adcon_restart.sh':
    ensure => file,
    source => 'puppet:///modules/adminconsole/scripts/adcon_restart.sh',
    owner  => root,
    group  => root,
    mode   => '0755',
  }

  cron { 'adcon restart':
    ensure  => absent,
    command => '/usr/local/scripts/adcon_restart.sh >> /root/adcon_restart.log 2>&1',
    user    => root,
    minute  => 5,
    hour    => 1,
    weekday => 0,
    require => File['/usr/local/scripts/adcon_restart.sh'],
  }
}
