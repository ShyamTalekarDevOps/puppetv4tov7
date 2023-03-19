# == Class: mimecast_sea_star_server_toolkit::apps_config
# Config resources for sea star web apps configs
#
class mimecast_sea_star_server_toolkit::apps_config (
  $apps_appid = '',
  $apps_appkey = '',
  $adcon_appid = '',
  $adcon_appkey = '',
  $casereview_appid = '',
  $casereview_appkey = '',
  $cloudprotect_appid = '',
  $cloudprotect_appkey = '',
  $connect_appid = '',
  $connect_appkey = '',
  $matfe_appid = '',
  $matfe_appkey = '',
  $matpwp_appid = '',
  $matpwp_appkey = '',
  $mateup_appid = '',
  $mateup_appkey = '',
  $moa_appid = '',
  $moa_appkey = '',
  $moasm_appid = '',
  $moasm_appkey = '',
  $threat_appid = '',
  $threat_appkey = '',
  $ttpwp_appid = '',
  $ttpwp_appkey = '',
  $ingesmgt_appid = '',
  $ingesmgt_appkey = '',
  $mbiwp_appid = '',
  $mbiwp_appkey = '',
  $swgwp_appid = '',
  $swgwp_appkey = '',
  $supervision_appid = '',
  $supervision_appkey = '',
  $onboarding_appid = '',
  $onboarding_appkey = '',
  $syncrecover_appid = '',
  $syncrecover_appkey = ''
) {
  $app_name = 'mimecast-sea-star-server-toolkit'
  $base_dir = "/usr/local/mimecast/${app_name}"
  $portal_appid = lookup('mimecast_web_container::apps_config::portal_appid')
  $portal_appkey = lookup('mimecast_web_container::apps_config::portal_appkey')

  $directories = [
    '/usr/local/mimecast/mimecast-sea-star-server-toolkit/dist/web-apps/matpwp/config',
    '/usr/local/mimecast/mimecast-sea-star-server-toolkit/dist/web-apps/moa/config',
    '/usr/local/mimecast/mimecast-sea-star-server-toolkit/dist/web-apps/SWGWP/config',
    '/usr/local/mimecast/mimecast-sea-star-server-toolkit/dist/web-apps/administration',
    '/usr/local/mimecast/mimecast-sea-star-server-toolkit/dist/web-apps/administration/config',
  ]

  File {
    ensure => present,
    owner  => 'mcuser',
    group  => 'mcuser',
    mode   => '0644',
  }

  file { '/usr/local/mimecast/mimecast-sea-star-server-toolkit/resources/app.config.schema.json':
    ensure => file,
    source => 'puppet:///modules/mimecast_sea_star_server_toolkit/resources/app.config.schema.json',
  }

  file { '/usr/local/mimecast/mimecast-sea-star-server-toolkit/cfg/cfg.json':
    content => template('mimecast_sea_star_server_toolkit/cfg.json.erb'),
    replace => true,
    require => File['/usr/local/mimecast/mimecast-sea-star-server-toolkit'],
  }

  file { '/usr/local/mimecast/mimecast-sea-star-server-toolkit/dist/web-apps/apps/config/cfg.json':
    ensure       => file,
    content      => template('mimecast_sea_star_server_toolkit/apps.app.json.erb'),
    validate_cmd => '/usr/bin/python3 -m jsonschema -i % /usr/local/mimecast/mimecast-sea-star-server-toolkit/resources/app.config.schema.json',
    replace      => true,
    require      => File['/usr/local/mimecast/mimecast-sea-star-server-toolkit'],
    notify       => Service['mimecast-sea-star-server-toolkit'],
  }

  file { '/usr/local/mimecast/mimecast-sea-star-server-toolkit/dist/web-apps/threat-dashboard/config/cfg.json':
    ensure       => file,
    content      => template('mimecast_sea_star_server_toolkit/threat-dashboard.app.json.erb'),
    validate_cmd => '/usr/bin/python3 -m jsonschema -i % /usr/local/mimecast/mimecast-sea-star-server-toolkit/resources/app.config.schema.json',
    replace      => true,
    require      => File['/usr/local/mimecast/mimecast-sea-star-server-toolkit'],
    notify       => Service['mimecast-sea-star-server-toolkit'],
  }

  file { '/usr/local/mimecast/mimecast-sea-star-server-toolkit/dist/web-apps/ingestion-management/config/cfg.json':
    ensure       => file,
    content      => template('mimecast_sea_star_server_toolkit/ingestion-management.app.json.erb'),
    validate_cmd => '/usr/bin/python3 -m jsonschema -i % /usr/local/mimecast/mimecast-sea-star-server-toolkit/resources/app.config.schema.json',
    replace      => true,
    require      => File['/usr/local/mimecast/mimecast-sea-star-server-toolkit'],
    notify       => Service['mimecast-sea-star-server-toolkit'],
  }

  file { '/usr/local/mimecast/mimecast-sea-star-server-toolkit/dist/web-apps/case-review/config/cfg.json':
    ensure       => file,
    content      => template('mimecast_sea_star_server_toolkit/case-review.app.json.erb'),
    validate_cmd => '/usr/bin/python3 -m jsonschema -i % /usr/local/mimecast/mimecast-sea-star-server-toolkit/resources/app.config.schema.json',
    replace      => true,
    require      => File['/usr/local/mimecast/mimecast-sea-star-server-toolkit'],
    notify       => Service['mimecast-sea-star-server-toolkit'],
  }

  file { '/usr/local/mimecast/mimecast-sea-star-server-toolkit/dist/web-apps/matfe/config/cfg.json':
    ensure       => file,
    content      => template('mimecast_sea_star_server_toolkit/matfe.app.json.erb'),
    validate_cmd => '/usr/bin/python3 -m jsonschema -i % /usr/local/mimecast/mimecast-sea-star-server-toolkit/resources/app.config.schema.json',
    replace      => true,
    require      => File['/usr/local/mimecast/mimecast-sea-star-server-toolkit'],
    notify       => Service['mimecast-sea-star-server-toolkit'],
  }

  file { '/usr/local/mimecast/mimecast-sea-star-server-toolkit/dist/web-apps/matfe-access/config/cfg.json':
    ensure       => file,
    content      => template('mimecast_sea_star_server_toolkit/matfe-access.app.json.erb'),
    validate_cmd => '/usr/bin/python3 -m jsonschema -i % /usr/local/mimecast/mimecast-sea-star-server-toolkit/resources/app.config.schema.json',
    replace      => true,
    require      => File['/usr/local/mimecast/mimecast-sea-star-server-toolkit'],
    notify       => Service['mimecast-sea-star-server-toolkit'],
  }

  file { '/usr/local/mimecast/mimecast-sea-star-server-toolkit/dist/web-apps/TTPWP/config/cfg.json':
    ensure       => file,
    content      => template('mimecast_sea_star_server_toolkit/mimecast-ttp-web-portal.app.json.erb'),
    validate_cmd => '/usr/bin/python3 -m jsonschema -i % /usr/local/mimecast/mimecast-sea-star-server-toolkit/resources/app.config.schema.json',
    replace      => true,
    require      => File['/usr/local/mimecast/mimecast-sea-star-server-toolkit'],
    notify       => Service['mimecast-sea-star-server-toolkit'],
  }

  file { '/usr/local/mimecast/mimecast-sea-star-server-toolkit/dist/web-apps/mimecast-bi-web-portal/config/cfg.json':
    ensure       => file,
    content      => template('mimecast_sea_star_server_toolkit/bi-web-portal.app.json.erb'),
    validate_cmd => '/usr/bin/python3 -m jsonschema -i % /usr/local/mimecast/mimecast-sea-star-server-toolkit/resources/app.config.schema.json',
    replace      => true,
    require      => File['/usr/local/mimecast/mimecast-sea-star-server-toolkit'],
    notify       => Service['mimecast-sea-star-server-toolkit'],
  }

  file { '/usr/local/mimecast/mimecast-sea-star-server-toolkit/dist/web-apps/matpwp/config/cfg.json':
    ensure       => file,
    content      => template('mimecast_sea_star_server_toolkit/matpwp.app.json.erb'),
    validate_cmd => '/usr/bin/python3 -m jsonschema -i % /usr/local/mimecast/mimecast-sea-star-server-toolkit/resources/app.config.schema.json',
    replace      => true,
    require      => File['/usr/local/mimecast/mimecast-sea-star-server-toolkit'],
    notify       => Service['mimecast-sea-star-server-toolkit'],
  }

  # Apps that need to be tested on DEV and QA for key rotation
  if ($::mc_grid =~ /^(DEV|QA)$/) {
    file { '/usr/local/mimecast/mimecast-sea-star-server-toolkit/dist/web-apps/sync-recover/config/cfg.json':
      ensure       => file,
      content      => template('mimecast_sea_star_server_toolkit/sync-recover.app.json.erb'),
      validate_cmd => '/usr/bin/python3 -m jsonschema -i % /usr/local/mimecast/mimecast-sea-star-server-toolkit/resources/app.config.schema.json',
      replace      => true,
      require      => File['/usr/local/mimecast/mimecast-sea-star-server-toolkit'],
      notify       => Service['mimecast-sea-star-server-toolkit'],
    }

    file { '/usr/local/mimecast/mimecast-sea-star-server-toolkit/dist/web-apps/mateup/config/cfg.json':
      ensure       => file,
      content      => template('mimecast_sea_star_server_toolkit/mateup.app.json.erb'),
      validate_cmd => '/usr/bin/python3 -m jsonschema -i % /usr/local/mimecast/mimecast-sea-star-server-toolkit/resources/app.config.schema.json',
      replace      => true,
      require      => File['/usr/local/mimecast/mimecast-sea-star-server-toolkit'],
      notify       => Service['mimecast-sea-star-server-toolkit'],
    }
  }

  # Apps that need to be tested on DEV and QA for key rotation
  if ($::mc_grid =~ /^(DEV|DEVRH|QA)$/) {
    file { '/usr/local/mimecast/mimecast-sea-star-server-toolkit/dist/web-apps/cloud-protect-dashboard/config/cfg.json':
      ensure       => file,
      content      => template('mimecast_sea_star_server_toolkit/cloud-protect-dashboard.app.json.erb'),
      validate_cmd => '/usr/bin/python3 -m jsonschema -i % /usr/local/mimecast/mimecast-sea-star-server-toolkit/resources/app.config.schema.json',
      replace      => true,
      require      => File['/usr/local/mimecast/mimecast-sea-star-server-toolkit'],
      #notify => Service['mimecast-sea-star-server-toolkit'],
    }
  }

  file { '/usr/local/mimecast/mimecast-sea-star-server-toolkit/dist/web-apps/onboarding/config/cfg.json':
    ensure       => file,
    content      => template('mimecast_sea_star_server_toolkit/onboarding.app.json.erb'),
    validate_cmd => '/usr/bin/python3 -m jsonschema -i % /usr/local/mimecast/mimecast-sea-star-server-toolkit/resources/app.config.schema.json',
    replace      => true,
    require      => File['/usr/local/mimecast/mimecast-sea-star-server-toolkit'],
    notify       => Service['mimecast-sea-star-server-toolkit'],
  }

  file { '/usr/local/mimecast/mimecast-sea-star-server-toolkit/dist/web-apps/moa/config/cfg.json':
    ensure       => file,
    content      => template('mimecast_sea_star_server_toolkit/moa.app.json.erb'),
    validate_cmd => '/usr/bin/python3 -m jsonschema -i % /usr/local/mimecast/mimecast-sea-star-server-toolkit/resources/app.config.schema.json',
    replace      => true,
    require      => File['/usr/local/mimecast/mimecast-sea-star-server-toolkit/dist/web-apps/moa/config'],
    notify       => Service['mimecast-sea-star-server-toolkit'],
  }

  file { '/usr/local/mimecast/mimecast-sea-star-server-toolkit/dist/web-apps/SWGWP/config/cfg.json':
    ensure       => file,
    content      => template('mimecast_sea_star_server_toolkit/swg-web-portal.app.json.erb'),
    validate_cmd => '/usr/bin/python3 -m jsonschema -i % /usr/local/mimecast/mimecast-sea-star-server-toolkit/resources/app.config.schema.json',
    replace      => true,
    require      => File['/usr/local/mimecast/mimecast-sea-star-server-toolkit'],
    notify       => Service['mimecast-sea-star-server-toolkit'],
  }

  file { '/usr/local/mimecast/mimecast-sea-star-server-toolkit/dist/web-apps/connect/config/cfg.json':
    ensure       => file,
    content      => template('mimecast_sea_star_server_toolkit/connect.app.json.erb'),
    validate_cmd => '/usr/bin/python3 -m jsonschema -i % /usr/local/mimecast/mimecast-sea-star-server-toolkit/resources/app.config.schema.json',
    replace      => true,
    require      => File['/usr/local/mimecast/mimecast-sea-star-server-toolkit'],
    #notify => Service['mimecast-sea-star-server-toolkit'],
  }

  if ($::mc_grid =~ /^(DEV|DEVRH|QA)$/) {
    file { '/usr/local/mimecast/mimecast-sea-star-server-toolkit/dist/web-apps/moa-sm/config/cfg.json':
      ensure       => file,
      content      => template('mimecast_sea_star_server_toolkit/moa-sm.app.json.erb'),
      validate_cmd => '/usr/bin/python3 -m jsonschema -i % /usr/local/mimecast/mimecast-sea-star-server-toolkit/resources/app.config.schema.json',
      replace      => true,
      require      => File['/usr/local/mimecast/mimecast-sea-star-server-toolkit'],
      notify       => Service['mimecast-sea-star-server-toolkit'],
    }
  }

  file { '/usr/local/mimecast/mimecast-sea-star-server-toolkit/dist/web-apps/administration/config/cfg.json':
    ensure       => file,
    content      => template('mimecast_sea_star_server_toolkit/administration.app.json.erb'),
    validate_cmd => '/usr/bin/python3 -m jsonschema -i % /usr/local/mimecast/mimecast-sea-star-server-toolkit/resources/app.config.schema.json',
    replace      => true,
    require      => File['/usr/local/mimecast/mimecast-sea-star-server-toolkit'],
    #notify => Service['mimecast-sea-star-server-toolkit'],
  }

  file { '/usr/local/mimecast/mimecast-sea-star-server-toolkit/dist/web-apps/portal/config/cfg.json':
    ensure       => file,
    content      => template('mimecast_sea_star_server_toolkit/portal.app.json.erb'),
    validate_cmd => '/usr/bin/python3 -m jsonschema -i % /usr/local/mimecast/mimecast-sea-star-server-toolkit/resources/app.config.schema.json',
    replace      => true,
    require      => File['/usr/local/mimecast/mimecast-sea-star-server-toolkit']
  }

  file { '/usr/local/mimecast/mimecast-sea-star-server-toolkit/dist/web-apps/supervision/config/cfg.json':
    ensure       => file,
    content      => template('mimecast_sea_star_server_toolkit/supervision.app.json.erb'),
    validate_cmd => '/usr/bin/python3 -m jsonschema -i % /usr/local/mimecast/mimecast-sea-star-server-toolkit/resources/app.config.schema.json',
    replace      => true,
    require      => File['/usr/local/mimecast/mimecast-sea-star-server-toolkit'],
    notify       => Service['mimecast-sea-star-server-toolkit'],
  }
}
