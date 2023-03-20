# == Class: mimecast_web_container::apps_config
# Config resources for web apps configs
#
class mimecast_web_container::apps_config (
  $mul_appid = '',
  $mul_appkey = '',
  $portal_appid = '',
  $portal_appkey = '',
  $reviewer_appid = '',
  $reviewer_appkey = '',
  $secure_appid = '',
  $secure_appkey = '',
  $sso_appid = '',
  $sso_appkey = '',
  $supervision_appid = '',
  $supervision_appkey = '',
  $apps_appid = '',
  $apps_appkey = '',
  $casereview_appid = '',
  $casereview_appkey = '',
  $cloudprotect_appid = '',
  $cloudprotect_appkey = '',
  $matfe_appid = '',
  $matfe_appkey = '',
  $moa_appid = '',
  $moa_appkey = '',
  $moasm_appid = '',
  $moasm_appkey = '',
  $threat_appid = '',
  $threat_appkey = '',
  $onboarding_appid = '',
  $onboarding_appkey = '',
) {
  $app_name = 'mimecast-web-container'
  $base_dir = "/usr/local/mimecast/${app_name}"
  $directories = [
    '/usr/local/mimecast/mimecast-web-container'
  ]

  File {
    ensure => file,
    owner  => 'mcuser',
    group  => 'mcuser',
    mode   => '0644',
  }

  # Apps that have been tested on dev-sl-4 and qa-sl-1 and rolled out

  # Saving this in case CP-6630 needs working on
  # if ($::mc_grid != 'SND') {

  #   file { '/usr/local/mimecast/mimecast-web-container/cfg/mimecast-connect.app.json':
  #     ensure       => file,
  #     content      => template('mimecast_web_container/mimecast-connect.app.json.erb'),
  #     validate_cmd => '/usr/bin/python3 -m jsonschema -i % /usr/local/mimecast/mimecast-web-container/resources/mimecast-web-container.app.schema.json',
  #     replace      => true,
  #     require      => File['/usr/local/mimecast/mimecast-web-container'],
  #     notify       => Service['mimecast-web-container'],
  #   }
  # }

    file { '/usr/local/mimecast/mimecast-web-container/cfg/mimecast-large-files.app.json':
      ensure       => file,
      content      => template('mimecast_web_container/mimecast-large-files.app.json.erb'),
      validate_cmd => '/usr/bin/python3 -m jsonschema -i % /usr/local/mimecast/mimecast-web-container/resources/mimecast-web-container.app.schema.json',
      replace      => true,
      require      => File['/usr/local/mimecast/mimecast-web-container'],
      notify       => Service['mimecast-web-container'],
    }

    file { '/usr/local/mimecast/mimecast-web-container/cfg/mimecast-portal.app.json':
      ensure       => file,
      content      => template('mimecast_web_container/mimecast-portal.app.json.erb'),
      validate_cmd => '/usr/bin/python3 -m jsonschema -i % /usr/local/mimecast/mimecast-web-container/resources/mimecast-web-container.app.schema.json',
      replace      => true,
      require      => File['/usr/local/mimecast/mimecast-web-container'],
      notify       => Service['mimecast-web-container'],
    }

    file { '/usr/local/mimecast/mimecast-web-container/cfg/mimecast-secure.app.json':
      ensure       => file,
      content      => template('mimecast_web_container/mimecast-secure.app.json.erb'),
      validate_cmd => '/usr/bin/python3 -m jsonschema -i % /usr/local/mimecast/mimecast-web-container/resources/mimecast-web-container.app.schema.json',
      replace      => true,
      require      => File['/usr/local/mimecast/mimecast-web-container'],
      notify       => Service['mimecast-web-container'],
    }

    file { '/usr/local/mimecast/mimecast-web-container/cfg/mimecast-reviewer.app.json':
      ensure       => file,
      content      => template('mimecast_web_container/mimecast-reviewer.app.json.erb'),
      validate_cmd => '/usr/bin/python3 -m jsonschema -i % /usr/local/mimecast/mimecast-web-container/resources/mimecast-web-container.app.schema.json',
      replace      => true,
      require      => File['/usr/local/mimecast/mimecast-web-container'],
      notify       => Service['mimecast-web-container'],
    }

    file { '/usr/local/mimecast/mimecast-web-container/cfg/mimecast-supervision.app.json':
      ensure       => file,
      content      => template('mimecast_web_container/mimecast-supervision.app.json.erb'),
      validate_cmd => '/usr/bin/python3 -m jsonschema -i % /usr/local/mimecast/mimecast-web-container/resources/mimecast-web-container.app.schema.json',
      replace      => true,
      require      => File['/usr/local/mimecast/mimecast-web-container'],
      notify       => Service['mimecast-web-container'],
    }

    file { '/usr/local/mimecast/mimecast-web-container/cfg/mimecast-case-review.app.json':
      ensure       => file,
      content      => template('mimecast_web_container/mimecast-case-review.app.json.erb'),
      validate_cmd => '/usr/bin/python3 -m jsonschema -i % /usr/local/mimecast/mimecast-web-container/resources/mimecast-web-container.app.schema.json',
      replace      => true,
      require      => File['/usr/local/mimecast/mimecast-web-container'],
      notify       => Service['mimecast-web-container'],
    }

    file { '/usr/local/mimecast/mimecast-web-container/cfg/mimecast-threat.app.json':
      ensure       => file,
      content      => template('mimecast_web_container/mimecast-threat.app.json.erb'),
      validate_cmd => '/usr/bin/python3 -m jsonschema -i % /usr/local/mimecast/mimecast-web-container/resources/mimecast-web-container.app.schema.json',
      replace      => true,
      require      => File['/usr/local/mimecast/mimecast-web-container'],
      notify       => Service['mimecast-web-container'],
    }

    file { '/usr/local/mimecast/mimecast-web-container/cfg/mimecast-matfe.app.json':
      ensure       => file,
      content      => template('mimecast_web_container/mimecast-matfe.app.json.erb'),
      validate_cmd => '/usr/bin/python3 -m jsonschema -i % /usr/local/mimecast/mimecast-web-container/resources/mimecast-web-container.app.schema.json',
      replace      => true,
      require      => File['/usr/local/mimecast/mimecast-web-container'],
      notify       => Service['mimecast-web-container'],
    }

  # Apps that have been tested on dev-sl-4 and qa-sl-1 and ready for rolling out
  if ($::mc_grid =~ /^(DEV|DEVRH|QA)$/ ) {
    file { '/usr/local/mimecast/mimecast-web-container/cfg/mimecast-cloud-protect.app.json':
      ensure       => file,
      content      => template('mimecast_web_container/mimecast-cloud-protect.app.json.erb'),
      validate_cmd => '/usr/bin/python3 -m jsonschema -i % /usr/local/mimecast/mimecast-web-container/resources/mimecast-web-container.app.schema.json',
      replace      => true,
      require      => File['/usr/local/mimecast/mimecast-web-container'],
      notify       => Service['mimecast-web-container'],
    }
  }

  file { '/usr/local/mimecast/mimecast-web-container/cfg/mimecast-onboarding.app.json':
    ensure       => file,
    content      => template('mimecast_web_container/mimecast-onboarding.app.json.erb'),
    validate_cmd => '/usr/bin/python3 -m jsonschema -i % /usr/local/mimecast/mimecast-web-container/resources/mimecast-web-container.app.schema.json',
    replace      => true,
    require      => File['/usr/local/mimecast/mimecast-web-container'],
    notify       => Service['mimecast-web-container'],
  }

    file { '/usr/local/mimecast/mimecast-web-container/cfg/mimecast-sso.app.json':
      ensure       => file,
      content      => template('mimecast_web_container/mimecast-sso.app.json.erb'),
      validate_cmd => '/usr/bin/python3 -m jsonschema -i % /usr/local/mimecast/mimecast-web-container/resources/mimecast-web-container.app.schema.json',
      replace      => true,
      require      => File['/usr/local/mimecast/mimecast-web-container'],
      notify       => Service['mimecast-web-container'],
    }

    file { '/usr/local/mimecast/mimecast-web-container/cfg/mimecast-apps.app.json':
      ensure       => file,
      content      => template('mimecast_web_container/mimecast-apps.app.json.erb'),
      validate_cmd => '/usr/bin/python3 -m jsonschema -i % /usr/local/mimecast/mimecast-web-container/resources/mimecast-web-container.app.schema.json',
      replace      => true,
      require      => File['/usr/local/mimecast/mimecast-web-container'],
      notify       => Service['mimecast-web-container'],
    }

    file { '/usr/local/mimecast/mimecast-web-container/cfg/mimecast-universal-login.app.json':
      ensure       => file,
      content      => template('mimecast_web_container/mimecast-universal-login.app.json.erb'),
      validate_cmd => '/usr/bin/python3 -m jsonschema -i % /usr/local/mimecast/mimecast-web-container/resources/mimecast-web-container.app.schema.json',
      replace      => true,
      require      => File['/usr/local/mimecast/mimecast-web-container'],
      notify       => Service['mimecast-web-container'],
    }

    file { '/usr/local/mimecast/mimecast-web-container/cfg/mimecast-moa.app.json':
      ensure       => file,
      content      => template('mimecast_web_container/mimecast-moa.app.json.erb'),
      validate_cmd =>
        '/usr/bin/python3 -m jsonschema -i % /usr/local/mimecast/mimecast-web-container/resources/mimecast-web-container.app.schema.json'
      ,
      replace      => true,
      require      => File['/usr/local/mimecast/mimecast-web-container'],
      notify       => Service['mimecast-web-container'],
    }

    if ($::mc_grid =~ /^(DEV|DEVRH|QA)$/ ) {
      file { '/usr/local/mimecast/mimecast-web-container/cfg/mimecast-moa-sm.app.json':
        ensure       => file,
        content      => template('mimecast_web_container/mimecast-moa-sm.app.json.erb'),
        validate_cmd =>
          '/usr/bin/python3 -m jsonschema -i % /usr/local/mimecast/mimecast-web-container/resources/mimecast-web-container.app.schema.json'
        ,
        replace      => true,
        require      => File['/usr/local/mimecast/mimecast-web-container'],
        notify       => Service['mimecast-web-container'],
      }
    }
}
