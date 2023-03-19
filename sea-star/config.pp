#
class mimecast_sea_star_server_toolkit::config {
  $app_name = 'mimecast-sea-star-server-toolkit'
  $base_dir = "/usr/local/mimecast/${app_name}"
  File {
    ensure => present,
    owner  => 'mcuser',
    group  => 'mcuser',
    mode   => '0644',
  }

  $certificate_lookup = regsubst("wildcard.${::domain}", '\.', '_', 'G')
  $cert = lookup($certificate_lookup, {}, 'internal_certs')

  file { '/usr/local/mimecast/mimecast-sea-star-server-toolkit':
    ensure => directory,
  }

  file { '/etc/logrotate.d/seastar-console.conf':
    source => 'puppet:///modules/mimecast_sea_star_server_toolkit/logrotate.d/seastar-console.conf',
    mode   => '0644',
    owner  => root,
    group  => root,
  }

  file { [
    '/usr/local/mimecast/mimecast-sea-star-server-toolkit/cfg',
    '/usr/local/mimecast/mimecast-sea-star-server-toolkit/dist',
    '/usr/local/mimecast/mimecast-sea-star-server-toolkit/dist/web-apps',
    '/usr/local/mimecast/mimecast-sea-star-server-toolkit/dist/web-apps/administration',
    '/usr/local/mimecast/mimecast-sea-star-server-toolkit/dist/web-apps/administration/config',
    '/usr/local/mimecast/mimecast-sea-star-server-toolkit/dist/web-apps/SWGWP',
    '/usr/local/mimecast/mimecast-sea-star-server-toolkit/dist/web-apps/SWGWP/config',
    '/usr/local/mimecast/mimecast-sea-star-server-toolkit/dist/web-apps/TTPWP',
    '/usr/local/mimecast/mimecast-sea-star-server-toolkit/dist/web-apps/TTPWP/config',
    '/usr/local/mimecast/mimecast-sea-star-server-toolkit/dist/web-apps/apps',
    '/usr/local/mimecast/mimecast-sea-star-server-toolkit/dist/web-apps/apps/config',
    '/usr/local/mimecast/mimecast-sea-star-server-toolkit/dist/web-apps/branding',
    '/usr/local/mimecast/mimecast-sea-star-server-toolkit/dist/web-apps/case-review',
    '/usr/local/mimecast/mimecast-sea-star-server-toolkit/dist/web-apps/case-review/config',
    '/usr/local/mimecast/mimecast-sea-star-server-toolkit/dist/web-apps/common',
    '/usr/local/mimecast/mimecast-sea-star-server-toolkit/dist/web-apps/common/config',
    '/usr/local/mimecast/mimecast-sea-star-server-toolkit/dist/web-apps/connect',
    '/usr/local/mimecast/mimecast-sea-star-server-toolkit/dist/web-apps/connect/config',
    '/usr/local/mimecast/mimecast-sea-star-server-toolkit/dist/web-apps/ingestion-management',
    '/usr/local/mimecast/mimecast-sea-star-server-toolkit/dist/web-apps/ingestion-management/config',
    '/usr/local/mimecast/mimecast-sea-star-server-toolkit/dist/web-apps/matfe',
    '/usr/local/mimecast/mimecast-sea-star-server-toolkit/dist/web-apps/matfe/config',
    '/usr/local/mimecast/mimecast-sea-star-server-toolkit/dist/web-apps/matfe-access',
    '/usr/local/mimecast/mimecast-sea-star-server-toolkit/dist/web-apps/matfe-access/config',
    '/usr/local/mimecast/mimecast-sea-star-server-toolkit/dist/web-apps/mateup',
    '/usr/local/mimecast/mimecast-sea-star-server-toolkit/dist/web-apps/mateup/config',
    '/usr/local/mimecast/mimecast-sea-star-server-toolkit/dist/web-apps/mimecast-bi-web-portal',
    '/usr/local/mimecast/mimecast-sea-star-server-toolkit/dist/web-apps/mimecast-bi-web-portal/config',
    '/usr/local/mimecast/mimecast-sea-star-server-toolkit/dist/web-apps/moa/',
    '/usr/local/mimecast/mimecast-sea-star-server-toolkit/dist/web-apps/moa/config',
    '/usr/local/mimecast/mimecast-sea-star-server-toolkit/dist/web-apps/supervision',
    '/usr/local/mimecast/mimecast-sea-star-server-toolkit/dist/web-apps/supervision/config',
    '/usr/local/mimecast/mimecast-sea-star-server-toolkit/dist/web-apps/threat-dashboard',
    '/usr/local/mimecast/mimecast-sea-star-server-toolkit/dist/web-apps/threat-dashboard/config',
    '/usr/local/mimecast/mimecast-sea-star-server-toolkit/dist/web-apps/sync-recover',
    '/usr/local/mimecast/mimecast-sea-star-server-toolkit/dist/web-apps/sync-recover/config',
    '/usr/local/mimecast/mimecast-sea-star-server-toolkit/dist/web-apps/onboarding',
    '/usr/local/mimecast/mimecast-sea-star-server-toolkit/dist/web-apps/onboarding/config',
    '/usr/local/mimecast/mimecast-sea-star-server-toolkit/dist/web-apps/portal',
    '/usr/local/mimecast/mimecast-sea-star-server-toolkit/dist/web-apps/portal/config',
    '/usr/local/mimecast/mimecast-sea-star-server-toolkit/log',
    '/usr/local/mimecast/mimecast-sea-star-server-toolkit/resources'
  ]:
    ensure => directory,
    owner  => mcuser,
    group  => mcuser,
  }

  if $::fqdn == 'dev-sl-5.dev.mimecast.lan' {
    $template_name = "${app_name}_new"
    file { '/opt/rh/rh-nodejs8/service-environment':
      source => 'puppet:///modules/mimecast_sea_star_server_toolkit/service-environment'
    }
  }
  else {
    $template_name = "${app_name}"
  }

  if $::operatingsystemmajrelease == '6' {
    $init_script = "/etc/init.d/${app_name}"
    $owner = 'root'
  }
  else {
    file { "/etc/systemd/system/${app_name}.service":
      ensure  => present,
      content => template("mimecast_sea_star_server_toolkit/${template_name}.service.erb"),
      owner   => root,
      group   => root,
      mode    => '0644',
      notify  => Exec["${app_name}_reload_systemd"],
      before  => Service[$app_name],
    }
    file { [ '/usr/local/mimecast/mimecast-sea-star-server-toolkit/bin' ]:
      ensure => directory,
      owner  => root,
      group  => root,
    }
    $init_script = "${base_dir}/bin/${app_name}"
    $owner = 'mcuser'
    exec { "${app_name}_reload_systemd":
      command     => '/usr/bin/systemctl daemon-reload',
      refreshonly => true,
      notify      => Service[$app_name],
    }
  }

  file { $init_script:
    owner  => $owner,
    group  => $owner,
    mode   => '0755',
    source => [
      'puppet:///modules/mimecast_sea_star_server_toolkit/mimecast-sea-star-server-toolkit'
    ]
  }

  $ssl_dir = '/usr/local/mimecast/mimecast-sea-star-server-toolkit/ssl'

  file { $ssl_dir:
    ensure => directory,
  }

  # Deploy asterisk/wildcard certs
  ## Jersey seastar gets both mimecast.com and mimecast-offshore.com.
  ## mc_publicdomain is mimecast-offshore in Jersey, so we need to explicitly give it mimecast.com here
  if ($::mc_grid == 'Jersey') {
    $onshore_certificate = lookup(regsubst('wildcard.mimecast.com', '\.', '_', 'G'))
    file { "${ssl_dir}/asterisk.mimecast.com.cert.pem":
      ensure  => present,
      content => $onshore_certificate['crt'],
      owner   => mcuser,
      group   => root,
      mode    => '0600',
      require => File[$ssl_dir],
      notify  => Service['mimecast-sea-star-server-toolkit'],
    }

    file { "${ssl_dir}/asterisk.mimecast.com.key.pem":
      ensure  => present,
      content => $onshore_certificate['key'],
      owner   => mcuser,
      group   => root,
      mode    => '0600',
      require => File[$ssl_dir],
      notify  => Service['mimecast-sea-star-server-toolkit'],
    }
  }
  ## Non-Jersey hosts only need their own mc_publicdomain cert
  ## Here we do the mc_publicdomain cert for all other grids AND jersey
  $publicdomain_certificate = lookup(regsubst("wildcard.${::mc_publicdomain}", '\.', '_', 'G'))
  file { "${ssl_dir}/asterisk.${::mc_publicdomain}.cert.pem":
    ensure  => present,
    owner   => mcuser,
    group   => root,
    replace => true,
    mode    => '0400',
    require => File[$ssl_dir],
    content => $publicdomain_certificate['crt'],
    notify  => Service['mimecast-sea-star-server-toolkit'],
  }
  file { "${ssl_dir}/asterisk.${::mc_publicdomain}.key.pem":
    ensure  => present,
    owner   => mcuser,
    group   => root,
    replace => true,
    mode    => '0400',
    require => File[$ssl_dir],
    content => $publicdomain_certificate['key'],
    notify  => Service['mimecast-sea-star-server-toolkit'],
  }

  # TOINF-36632 - DEV gets production wildcard for testing.
  # SEOPS-something: ^this is exactly what we're trying to undo now, thanks to foxes.
  if ( $::mc_grid =~ /DEV|QA|LT|STG|STGRH|DEVRH/ ) {
    pki_client::cert { "pg_wildcard.${::domain}":
      certname => $::domain,
      key      => $cert['key'],
      crt      => $cert['crt'],
      owner    => 'mcuser',
      group    => 'mcuser',
      key_dir  => $ssl_dir,
      crt_dir  => $ssl_dir,
      require  => File[$ssl_dir],
    }
    # Dummy offshore cert for pre-prod
    file { "${ssl_dir}/dev.mimecast-offshore.com.cert.crt":
      ensure  => present,
      source  => 'puppet:///modules/mimecast_sea_star_server_toolkit/ssl/dev.mimecast-offshore.com.cert.crt',
      owner   => 'mcuser',
      group   => 'mcuser',
      mode    => '0600',
      require => File[$ssl_dir],
      notify  => Service['mimecast-sea-star-server-toolkit'],
    }
    file { "${ssl_dir}/dev.mimecast-offshore.com.key.pem":
      ensure  => present,
      source  => 'puppet:///modules/mimecast_sea_star_server_toolkit/ssl/dev.mimecast-offshore.com.key.pem',
      owner   => 'mcuser',
      group   => 'mcuser',
      mode    => '0600',
      require => File[$ssl_dir],
      notify  => Service['mimecast-sea-star-server-toolkit'],
    }
  }

  #WF-4186
  file { '/usr/local/mimecast/mimecast-sea-star-server-toolkit/resources/caps-override.schema.json':
    ensure => file,
    source => 'puppet:///modules/mimecast_sea_star_server_toolkit/resources/caps-override.schema.json',
  }
  file { '/usr/local/mimecast/mimecast-sea-star-server-toolkit/resources/config.schema.json':
    ensure => file,
    source => 'puppet:///modules/mimecast_sea_star_server_toolkit/resources/config.schema.json',
  }

  #MAT-3059
  file { '/usr/local/mimecast/mimecast-sea-star-server-toolkit/resources/aws_config.schema.json':
    ensure => file,
    source => 'puppet:///modules/mimecast_sea_star_server_toolkit/resources/aws_config.schema.json',
  }

  if ( $::mc_grid =~ /DEV|QA|UK|STG/ ) {
    file { '/usr/local/mimecast/mimecast-sea-star-server-toolkit/dist/web-apps/TTPWP/config/caps-override.json':
      source => [
        "puppet:///modules/mimecast_sea_star_server_toolkit/caps/TTPWP/${::mc_grid}/${::domain}/${::hostname}/caps-override.json",
        "puppet:///modules/mimecast_sea_star_server_toolkit/caps/TTPWP/${::mc_grid}/${::domain}/${::mc_servertype}/caps-override.json",
        "puppet:///modules/mimecast_sea_star_server_toolkit/caps/TTPWP/${::mc_grid}/${::domain}/caps-override.json",
        "puppet:///modules/mimecast_sea_star_server_toolkit/caps/TTPWP/${::mc_grid}/${::hostname}/caps-override.json",
        "puppet:///modules/mimecast_sea_star_server_toolkit/caps/TTPWP/${::mc_grid}/${::mc_servertype}/caps-override.json",
        "puppet:///modules/mimecast_sea_star_server_toolkit/caps/TTPWP/${::mc_grid}/caps-override.json",
        "puppet:///modules/mimecast_sea_star_server_toolkit/caps/TTPWP/${::mc_servertype}/caps-override.json",
        'puppet:///modules/mimecast_sea_star_server_toolkit/caps/TTPWP/caps-override.json'
      ],
      owner  => 'mcuser',
      group  => 'mcuser',
    }
  }

  file { '/usr/local/mimecast/mimecast-sea-star-server-toolkit/dist/web-apps/administration/config/caps-override.json':
    source       => [
      "puppet:///modules/mimecast_sea_star_server_toolkit/caps/administration/${::mc_grid}/${::domain}/${::hostname}/caps-override.json",
      "puppet:///modules/mimecast_sea_star_server_toolkit/caps/administration/${::mc_grid}/${::domain}/${::mc_servertype}/caps-override.json",
      "puppet:///modules/mimecast_sea_star_server_toolkit/caps/administration/${::mc_grid}/${::domain}/caps-override.json",
      "puppet:///modules/mimecast_sea_star_server_toolkit/caps/administration/${::mc_grid}/${::hostname}/caps-override.json",
      "puppet:///modules/mimecast_sea_star_server_toolkit/caps/administration/${::mc_grid}/${::mc_servertype}/caps-override.json",
      "puppet:///modules/mimecast_sea_star_server_toolkit/caps/administration/${::mc_grid}/caps-override.json",
      "puppet:///modules/mimecast_sea_star_server_toolkit/caps/administration/${::mc_servertype}/caps-override.json",
      'puppet:///modules/mimecast_sea_star_server_toolkit/caps/administration/caps-override.json',

    ],
    owner        => 'mcuser',
    group        => 'mcuser',
    validate_cmd => '/usr/bin/python3 -m jsonschema -i % /usr/local/mimecast/mimecast-sea-star-server-toolkit/resources/caps-override.schema.json',
    require      => File['/usr/local/mimecast/mimecast-sea-star-server-toolkit/resources/caps-override.schema.json'],
  }

  file { '/usr/local/mimecast/mimecast-sea-star-server-toolkit/dist/web-apps/threat-dashboard/config/caps-override.json':
    source       => [
      "puppet:///modules/mimecast_sea_star_server_toolkit/caps/threat-dashboard/${::mc_grid}/${::domain}/${::hostname}/caps-override.json",
      "puppet:///modules/mimecast_sea_star_server_toolkit/caps/threat-dashboard/${::mc_grid}/${::domain}/${::mc_servertype}/caps-override.json",
      "puppet:///modules/mimecast_sea_star_server_toolkit/caps/threat-dashboard/${::mc_grid}/${::domain}/caps-override.json",
      "puppet:///modules/mimecast_sea_star_server_toolkit/caps/threat-dashboard/${::mc_grid}/${::hostname}/caps-override.json",
      "puppet:///modules/mimecast_sea_star_server_toolkit/caps/threat-dashboard/${::mc_grid}/${::mc_servertype}/caps-override.json",
      "puppet:///modules/mimecast_sea_star_server_toolkit/caps/threat-dashboard/${::mc_grid}/caps-override.json",
      "puppet:///modules/mimecast_sea_star_server_toolkit/caps/threat-dashboard/${::mc_servertype}/caps-override.json",
      'puppet:///modules/mimecast_sea_star_server_toolkit/caps/threat-dashboard/caps-override.json',
    ],
    owner        => 'mcuser',
    group        => 'mcuser',
    validate_cmd => '/usr/bin/python3 -m jsonschema -i % /usr/local/mimecast/mimecast-sea-star-server-toolkit/resources/caps-override.schema.json',
    require      => File['/usr/local/mimecast/mimecast-sea-star-server-toolkit/resources/caps-override.schema.json'],
  }

  file { '/usr/local/mimecast/mimecast-sea-star-server-toolkit/dist/web-apps/case-review/config/caps-override.json':
    source       => [
      "puppet:///modules/mimecast_sea_star_server_toolkit/caps/case-review/${::mc_grid}/${::domain}/${::hostname}/caps-override.json",
      "puppet:///modules/mimecast_sea_star_server_toolkit/caps/case-review/${::mc_grid}/${::domain}/${::mc_servertype}/caps-override.json",
      "puppet:///modules/mimecast_sea_star_server_toolkit/caps/case-review/${::mc_grid}/${::domain}/caps-override.json",
      "puppet:///modules/mimecast_sea_star_server_toolkit/caps/case-review/${::mc_grid}/${::hostname}/caps-override.json",
      "puppet:///modules/mimecast_sea_star_server_toolkit/caps/case-review/${::mc_grid}/${::mc_servertype}/caps-override.json",
      "puppet:///modules/mimecast_sea_star_server_toolkit/caps/case-review/${::mc_grid}/caps-override.json",
      "puppet:///modules/mimecast_sea_star_server_toolkit/caps/case-review/${::mc_servertype}/caps-override.json",
      'puppet:///modules/mimecast_sea_star_server_toolkit/caps/case-review/caps-override.json',

    ],
    owner        => 'mcuser',
    group        => 'mcuser',
    validate_cmd => '/usr/bin/python3 -m jsonschema -i % /usr/local/mimecast/mimecast-sea-star-server-toolkit/resources/caps-override.schema.json',
    require      => File['/usr/local/mimecast/mimecast-sea-star-server-toolkit/resources/caps-override.schema.json'],
  }

  file { '/usr/local/mimecast/mimecast-sea-star-server-toolkit/dist/web-apps/ingestion-management/config/caps-override.json':
    source  => [
      "puppet:///modules/mimecast_sea_star_server_toolkit/caps/ingestion-management/${::mc_grid}/${::domain}/${::hostname}/caps-override.json",
      "puppet:///modules/mimecast_sea_star_server_toolkit/caps/ingestion-management/${::mc_grid}/${::domain}/${::mc_servertype}/caps-override.json",
      "puppet:///modules/mimecast_sea_star_server_toolkit/caps/ingestion-management/${::mc_grid}/${::domain}/caps-override.json",
      "puppet:///modules/mimecast_sea_star_server_toolkit/caps/ingestion-management/${::mc_grid}/${::hostname}/caps-override.json",
      "puppet:///modules/mimecast_sea_star_server_toolkit/caps/ingestion-management/${::mc_grid}/${::mc_servertype}/caps-override.json",
      "puppet:///modules/mimecast_sea_star_server_toolkit/caps/ingestion-management/${::mc_grid}/caps-override.json",
      "puppet:///modules/mimecast_sea_star_server_toolkit/caps/ingestion-management/${::mc_servertype}/caps-override.json",
      'puppet:///modules/mimecast_sea_star_server_toolkit/caps/ingestion-management/caps-override.json',

    ],
    require => File['/usr/local/mimecast/mimecast-sea-star-server-toolkit/dist/web-apps/ingestion-management/config'],
    owner   => 'mcuser',
    group   => 'mcuser',
  }

  file { '/usr/local/mimecast/mimecast-sea-star-server-toolkit/dist/web-apps/connect/config/caps-override.json':
    source       => [
      "puppet:///modules/mimecast_sea_star_server_toolkit/caps/connect/${::mc_grid}/${::domain}/${::hostname}/caps-override.json",
      "puppet:///modules/mimecast_sea_star_server_toolkit/caps/connect/${::mc_grid}/${::domain}/${::mc_servertype}/caps-override.json",
      "puppet:///modules/mimecast_sea_star_server_toolkit/caps/connect/${::mc_grid}/${::domain}/caps-override.json",
      "puppet:///modules/mimecast_sea_star_server_toolkit/caps/connect/${::mc_grid}/${::hostname}/caps-override.json",
      "puppet:///modules/mimecast_sea_star_server_toolkit/caps/connect/${::mc_grid}/${::mc_servertype}/caps-override.json",
      "puppet:///modules/mimecast_sea_star_server_toolkit/caps/connect/${::mc_grid}/caps-override.json",
      "puppet:///modules/mimecast_sea_star_server_toolkit/caps/connect/${::mc_servertype}/caps-override.json",
      'puppet:///modules/mimecast_sea_star_server_toolkit/caps/connect/caps-override.json',

    ],
    owner        => 'mcuser',
    group        => 'mcuser',
    validate_cmd => '/usr/bin/python3 -m jsonschema -i % /usr/local/mimecast/mimecast-sea-star-server-toolkit/resources/caps-override.schema.json',
    require      => File['/usr/local/mimecast/mimecast-sea-star-server-toolkit/resources/caps-override.schema.json'],
  }

  file { '/usr/local/mimecast/mimecast-sea-star-server-toolkit/dist/web-apps/supervision/config/caps-override.json':
    source       => [
      "puppet:///modules/mimecast_sea_star_server_toolkit/caps/supervision/${::mc_grid}/${::domain}/${::hostname}/caps-override.json",
      "puppet:///modules/mimecast_sea_star_server_toolkit/caps/supervision/${::mc_grid}/${::domain}/${::mc_servertype}/caps-override.json",
      "puppet:///modules/mimecast_sea_star_server_toolkit/caps/supervision/${::mc_grid}/${::domain}/caps-override.json",
      "puppet:///modules/mimecast_sea_star_server_toolkit/caps/supervision/${::mc_grid}/${::hostname}/caps-override.json",
      "puppet:///modules/mimecast_sea_star_server_toolkit/caps/supervision/${::mc_grid}/${::mc_servertype}/caps-override.json",
      "puppet:///modules/mimecast_sea_star_server_toolkit/caps/supervision/${::mc_grid}/caps-override.json",
      "puppet:///modules/mimecast_sea_star_server_toolkit/caps/supervision/${::mc_servertype}/caps-override.json",
      'puppet:///modules/mimecast_sea_star_server_toolkit/caps/supervision/caps-override.json',

    ],
    owner        => 'mcuser',
    group        => 'mcuser',
    validate_cmd => '/usr/bin/python3 -m jsonschema -i % /usr/local/mimecast/mimecast-sea-star-server-toolkit/resources/caps-override.schema.json',
    require      => File['/usr/local/mimecast/mimecast-sea-star-server-toolkit/resources/caps-override.schema.json'],
  }

  file { '/usr/local/mimecast/mimecast-sea-star-server-toolkit/dist/web-apps/onboarding/config/caps-override.json':
    source       => [
      "puppet:///modules/mimecast_sea_star_server_toolkit/caps/onboarding/${::mc_grid}/${::domain}/${::hostname}/caps-override.json",
      "puppet:///modules/mimecast_sea_star_server_toolkit/caps/onboarding/${::mc_grid}/${::domain}/${::mc_servertype}/caps-override.json",
      "puppet:///modules/mimecast_sea_star_server_toolkit/caps/onboarding/${::mc_grid}/${::domain}/caps-override.json",
      "puppet:///modules/mimecast_sea_star_server_toolkit/caps/onboarding/${::mc_grid}/${::hostname}/caps-override.json",
      "puppet:///modules/mimecast_sea_star_server_toolkit/caps/onboarding/${::mc_grid}/${::mc_servertype}/caps-override.json",
      "puppet:///modules/mimecast_sea_star_server_toolkit/caps/onboarding/${::mc_grid}/caps-override.json",
      "puppet:///modules/mimecast_sea_star_server_toolkit/caps/onboarding/${::mc_servertype}/caps-override.json",
      'puppet:///modules/mimecast_sea_star_server_toolkit/caps/onboarding/caps-override.json',
    ],
    owner        => 'mcuser',
    group        => 'mcuser',
    validate_cmd => '/usr/bin/python3 -m jsonschema -i % /usr/local/mimecast/mimecast-sea-star-server-toolkit/resources/caps-override.schema.json',
    require      => File['/usr/local/mimecast/mimecast-sea-star-server-toolkit/resources/caps-override.schema.json'],
  }

  file { '/usr/local/mimecast/mimecast-sea-star-server-toolkit/dist/web-apps/apps/config/caps-override.json':
    source       => [
      "puppet:///modules/mimecast_sea_star_server_toolkit/caps/apps/${::mc_grid}/${::domain}/${::hostname}/caps-override.json",
      "puppet:///modules/mimecast_sea_star_server_toolkit/caps/apps/${::mc_grid}/${::domain}/${::mc_servertype}/caps-override.json",
      "puppet:///modules/mimecast_sea_star_server_toolkit/caps/apps/${::mc_grid}/${::domain}/caps-override.json",
      "puppet:///modules/mimecast_sea_star_server_toolkit/caps/apps/${::mc_grid}/${::hostname}/caps-override.json",
      "puppet:///modules/mimecast_sea_star_server_toolkit/caps/apps/${::mc_grid}/${::mc_servertype}/caps-override.json",
      "puppet:///modules/mimecast_sea_star_server_toolkit/caps/apps/${::mc_grid}/caps-override.json",
      "puppet:///modules/mimecast_sea_star_server_toolkit/caps/apps/${::mc_servertype}/caps-override.json",
      'puppet:///modules/mimecast_sea_star_server_toolkit/caps/apps/caps-override.json',

    ],
    owner        => 'mcuser',
    group        => 'mcuser',
    validate_cmd => '/usr/bin/python3 -m jsonschema -i % /usr/local/mimecast/mimecast-sea-star-server-toolkit/resources/caps-override.schema.json',
    require      => File['/usr/local/mimecast/mimecast-sea-star-server-toolkit/resources/caps-override.schema.json'],
  }

  if ($::mc_grid !~ /DEV|QA|LT/) {
    file { '/etc/sysconfig/mimecast-sea-star-server-toolkit':
      ensure => 'present',
      owner  => root,
      group  => root,
      mode   => '0644',
      source => 'puppet:///modules/mimecast_sea_star_server_toolkit/production-sysconfig',
    }
  }

  file { '/usr/local/mimecast/mimecast-sea-star-server-toolkit/encryption.key':
    content   => base64('decode', lookup('mimecast_web_container::config::encryption_key')),
    replace   => true,
    show_diff => false,
    require   => File['/usr/local/mimecast/mimecast-sea-star-server-toolkit']
  }

  file { '/usr/local/mimecast/mimecast-sea-star-server-toolkit/signing.key':
    content   => base64('decode', lookup('mimecast_web_container::config::siging_key')),
    replace   => true,
    show_diff => false,
    require   => File['/usr/local/mimecast/mimecast-sea-star-server-toolkit']
  }

  logrotation::worker { 'mimecast-sea-star-server-toolkit-logs':
    service                 => ['mimecast-sea-star-server-toolkit-logs'],
    log_dir                 => ['/usr/local/mimecast/mimecast-sea-star-server-toolkit/log'],
    log_pattern_to_compress => ['*.log'],
    log_age_to_compress     => ['+0'],
    log_pattern_to_remove   => ['*.zst'],
    log_age_to_remove       => ['+60'],
  }

  $aws = lookup('xdk::aws')
  $aws_seastar = lookup('xdk::aws_seastar')
  $aws_cert = lookup('xdk::aws_cert')

  validate_hash($aws)

  file { '/usr/local/mimecast/mimecast-sea-star-server-toolkit/cfg/aws_config.json':
    ensure  => present,
    content => template("${module_name}/aws_config.json.erb"),
    owner   => mcuser,
    group   => mcuser,
    mode    => '0640',
    require => File['/usr/local/mimecast/mimecast-sea-star-server-toolkit/cfg']
  }

  file { '/usr/local/mimecast/mimecast-sea-star-server-toolkit/cfg/aws_cert.pem':
    ensure  => present,
    content => template("${module_name}/aws_cert.pem.erb"),
    owner   => mcuser,
    group   => mcuser,
    mode    => '0640',
    require => File['/usr/local/mimecast/mimecast-sea-star-server-toolkit/cfg'],
  }

  if ( $::mc_grid =~ /DEV|QA/ ) {
    file { '/usr/local/mimecast/mimecast-sea-star-server-toolkit/dist/web-apps/mateup/config/caps-override.json':
      source  => [
        "puppet:///modules/mimecast_sea_star_server_toolkit/caps/mateup/${::mc_grid}/${::domain}/${::hostname}/caps-override.json",
        "puppet:///modules/mimecast_sea_star_server_toolkit/caps/mateup/${::mc_grid}/${::domain}/${::mc_servertype}/caps-override.json",
        "puppet:///modules/mimecast_sea_star_server_toolkit/caps/mateup/${::mc_grid}/${::domain}/caps-override.json",
        "puppet:///modules/mimecast_sea_star_server_toolkit/caps/mateup/${::mc_grid}/${::hostname}/caps-override.json",
        "puppet:///modules/mimecast_sea_star_server_toolkit/caps/mateup/${::mc_grid}/${::mc_servertype}/caps-override.json",
        "puppet:///modules/mimecast_sea_star_server_toolkit/caps/mateup/${::mc_grid}/caps-override.json",
        "puppet:///modules/mimecast_sea_star_server_toolkit/caps/mateup/${::mc_servertype}/caps-override.json",
        'puppet:///modules/mimecast_sea_star_server_toolkit/caps/mateup/caps-override.json',
      ],
      require => File['/usr/local/mimecast/mimecast-sea-star-server-toolkit/dist/web-apps/mateup/config'],
      owner   => 'mcuser',
      group   => 'mcuser',
    }
  }

  file { '/usr/local/mimecast/mimecast-sea-star-server-toolkit/dist/web-apps/matfe-access/config/caps-override.json':
    source  => [
      "puppet:///modules/mimecast_sea_star_server_toolkit/caps/matfe-access/${::mc_grid}/${::domain}/${::hostname}/caps-override.json",
      "puppet:///modules/mimecast_sea_star_server_toolkit/caps/matfe-access/${::mc_grid}/${::domain}/${::mc_servertype}/caps-override.json",
      "puppet:///modules/mimecast_sea_star_server_toolkit/caps/matfe-access/${::mc_grid}/${::domain}/caps-override.json",
      "puppet:///modules/mimecast_sea_star_server_toolkit/caps/matfe-access/${::mc_grid}/${::hostname}/caps-override.json",
      "puppet:///modules/mimecast_sea_star_server_toolkit/caps/matfe-access/${::mc_grid}/${::mc_servertype}/caps-override.json",
      "puppet:///modules/mimecast_sea_star_server_toolkit/caps/matfe-access/${::mc_grid}/caps-override.json",
      "puppet:///modules/mimecast_sea_star_server_toolkit/caps/matfe-access/${::mc_servertype}/caps-override.json",
      'puppet:///modules/mimecast_sea_star_server_toolkit/caps/matfe-access/caps-override.json',
    ],
    require => File['/usr/local/mimecast/mimecast-sea-star-server-toolkit/dist/web-apps/matfe-access/config'],
    owner   => 'mcuser',
    group   => 'mcuser',
  }

  file { '/usr/local/mimecast/mimecast-sea-star-server-toolkit/dist/web-apps/matfe/config/caps-override.json':
    source       => [
      "puppet:///modules/mimecast_sea_star_server_toolkit/caps/matfe/${::mc_grid}/${::domain}/${::hostname}/caps-override.json",
      "puppet:///modules/mimecast_sea_star_server_toolkit/caps/matfe/${::mc_grid}/${::domain}/${::mc_servertype}/caps-override.json",
      "puppet:///modules/mimecast_sea_star_server_toolkit/caps/matfe/${::mc_grid}/${::domain}/caps-override.json",
      "puppet:///modules/mimecast_sea_star_server_toolkit/caps/matfe/${::mc_grid}/${::hostname}/caps-override.json",
      "puppet:///modules/mimecast_sea_star_server_toolkit/caps/matfe/${::mc_grid}/${::mc_servertype}/caps-override.json",
      "puppet:///modules/mimecast_sea_star_server_toolkit/caps/matfe/${::mc_grid}/caps-override.json",
      "puppet:///modules/mimecast_sea_star_server_toolkit/caps/matfe/${::mc_servertype}/caps-override.json",
      'puppet:///modules/mimecast_sea_star_server_toolkit/caps/matfe/caps-override.json',

    ],
    owner        => 'mcuser',
    group        => 'mcuser',
    validate_cmd => '/usr/bin/python3 -m jsonschema -i % /usr/local/mimecast/mimecast-sea-star-server-toolkit/resources/caps-override.schema.json',
    require      => File['/usr/local/mimecast/mimecast-sea-star-server-toolkit/resources/caps-override.schema.json'],
  }

  file { '/usr/local/mimecast/mimecast-sea-star-server-toolkit/dist/web-apps/common/config/caps-override.json':
    source       => [
      "puppet:///modules/mimecast_sea_star_server_toolkit/caps/common/${::mc_grid}/${::domain}/${::hostname}/caps-override.json",
      "puppet:///modules/mimecast_sea_star_server_toolkit/caps/common/${::mc_grid}/${::domain}/${::mc_servertype}/caps-override.json",
      "puppet:///modules/mimecast_sea_star_server_toolkit/caps/common/${::mc_grid}/${::domain}/caps-override.json",
      "puppet:///modules/mimecast_sea_star_server_toolkit/caps/common/${::mc_grid}/${::hostname}/caps-override.json",
      "puppet:///modules/mimecast_sea_star_server_toolkit/caps/common/${::mc_grid}/${::mc_servertype}/caps-override.json",
      "puppet:///modules/mimecast_sea_star_server_toolkit/caps/common/${::mc_grid}/caps-override.json",
      "puppet:///modules/mimecast_sea_star_server_toolkit/caps/common/${::mc_servertype}/caps-override.json",
      'puppet:///modules/mimecast_sea_star_server_toolkit/caps/common/caps-override.json',

    ],
    owner        => 'mcuser',
    group        => 'mcuser',
    validate_cmd => '/usr/bin/python3 -m jsonschema -i % /usr/local/mimecast/mimecast-sea-star-server-toolkit/resources/caps-override.schema.json',
    require      => File['/usr/local/mimecast/mimecast-sea-star-server-toolkit/resources/caps-override.schema.json'],
  }

  file { '/usr/local/mimecast/mimecast-sea-star-server-toolkit/dist/web-apps/sync-recover/config/caps-override.json':
    source       => [
      "puppet:///modules/mimecast_sea_star_server_toolkit/caps/sync-recover/${::mc_grid}/${::domain}/${::hostname}/caps-override.json",
      "puppet:///modules/mimecast_sea_star_server_toolkit/caps/sync-recover/${::mc_grid}/${::domain}/${::mc_servertype}/caps-override.json",
      "puppet:///modules/mimecast_sea_star_server_toolkit/caps/sync-recover/${::mc_grid}/${::domain}/caps-override.json",
      "puppet:///modules/mimecast_sea_star_server_toolkit/caps/sync-recover/${::mc_grid}/${::hostname}/caps-override.json",
      "puppet:///modules/mimecast_sea_star_server_toolkit/caps/sync-recover/${::mc_grid}/${::mc_servertype}/caps-override.json",
      "puppet:///modules/mimecast_sea_star_server_toolkit/caps/sync-recover/${::mc_grid}/caps-override.json",
      "puppet:///modules/mimecast_sea_star_server_toolkit/caps/sync-recover/${::mc_servertype}/caps-override.json",
      'puppet:///modules/mimecast_sea_star_server_toolkit/caps/sync-recover/caps-override.json',

    ],
    owner        => 'mcuser',
    group        => 'mcuser',
    validate_cmd => '/usr/bin/python3 -m jsonschema -i % /usr/local/mimecast/mimecast-sea-star-server-toolkit/resources/caps-override.schema.json',
    require      => File['/usr/local/mimecast/mimecast-sea-star-server-toolkit/resources/caps-override.schema.json'],
  }

  # caps for testing cloud protect
  if( $::mc_grid =~ /^(DEV)$/ ) {
    file { [
      '/usr/local/mimecast/mimecast-sea-star-server-toolkit/dist/web-apps/cloud-protect-dashboard',
      '/usr/local/mimecast/mimecast-sea-star-server-toolkit/dist/web-apps/cloud-protect-dashboard/config'
    ]:
      ensure => directory,
      owner  => mcuser,
      group  => mcuser,
    }
    file { '/usr/local/mimecast/mimecast-sea-star-server-toolkit/dist/web-apps/cloud-protect-dashboard/config/caps-override.json':
      source       => [
        "puppet:///modules/mimecast_sea_star_server_toolkit/caps/cloud-protect-dashboard/${::mc_grid}/${::domain}/${::hostname}/caps-override.json",
        "puppet:///modules/mimecast_sea_star_server_toolkit/caps/cloud-protect-dashboard/${::mc_grid}/${::domain}/${::mc_servertype}/caps-override.json",
        "puppet:///modules/mimecast_sea_star_server_toolkit/caps/cloud-protect-dashboard/${::mc_grid}/${::domain}/caps-override.json",
        "puppet:///modules/mimecast_sea_star_server_toolkit/caps/cloud-protect-dashboard/${::mc_grid}/${::hostname}/caps-override.json",
        "puppet:///modules/mimecast_sea_star_server_toolkit/caps/cloud-protect-dashboard/${::mc_grid}/${::mc_servertype}/caps-override.json",
        "puppet:///modules/mimecast_sea_star_server_toolkit/caps/cloud-protect-dashboard/${::mc_grid}/caps-override.json",
        "puppet:///modules/mimecast_sea_star_server_toolkit/caps/cloud-protect-dashboard/${::mc_servertype}/caps-override.json",
        'puppet:///modules/mimecast_sea_star_server_toolkit/caps/cloud-protect-dashboard/caps-override.json',

      ],
      owner        => 'mcuser',
      group        => 'mcuser',
      validate_cmd => '/usr/bin/python3 -m jsonschema -i % /usr/local/mimecast/mimecast-sea-star-server-toolkit/resources/caps-override.schema.json',
      require      => File['/usr/local/mimecast/mimecast-sea-star-server-toolkit/resources/caps-override.schema.json'],
    }
  }
}
