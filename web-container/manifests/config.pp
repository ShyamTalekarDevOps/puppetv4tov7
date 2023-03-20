#
class mimecast_web_container::config (
  $siging_key = undef,
  $encryption_key = undef,
  $adcon_appid = "",
  $adcon_appkey = "",
  $swg_cert = "",
  $mimeos_credentials = {},
) {
  $app_name = 'mimecast-web-container'
  $base_dir = "/usr/local/mimecast/${app_name}"

  $directories = [
    '/usr/local/mimecast/mimecast-web-container',
    '/usr/local/mimecast/mimecast-web-container/tmp',
    '/usr/local/mimecast/mimecast-web-container/cfg',
    '/usr/local/mimecast/mimecast-web-container/tmp/mc-uploaded-files',
    '/usr/local/mimecast/mimecast-web-container/resources',
    '/usr/local/mimecast/mimecast-web-container/config'
  ]

  if $::mc_servertype == 'adcon' {
    contain mimecast_web_container::kafka_config

    if ($::mc_grid != 'USPCOM' or $::mc_grid != 'USPGOV' or $::mc_alpha=='true') {
      $turbo_keys = hiera_hash('turbo')
      $turbo_encryption_encryption_key_base64 = $turbo_keys['turbo_encryption_encryption_key_base64']
      $turbo_encryption_signed_key_base64 = $turbo_keys['turbo_encryption_signed_key_base64']

      file { "${base_dir}/cfg/api-turbo.json":
        ensure  => 'present',
        owner   => 'mcuser',
        group   => 'mcuser',
        content => template('mimecast_web_container/api-turbo.json.erb'),
        replace => true,
        mode    => '0600'
      }
    }
  }

  if $::mc_grid == 'DEV' {
    file { "/usr/local/mimecast/secret":
      ensure => directory,
      mode   => '0755',
    }

    file { "/usr/local/mimecast/secret/credentials.json":
      content => inline_template('<%= JSON.pretty_generate(@mimeos_credentials) %>'),
      mode    => '0655'
    }
  }


  File {
    ensure => file,
    owner  => 'mcuser',
    group  => 'mcuser',
    mode   => '0644',
  }

  file { $directories:
    ensure => directory,
    mode   => '0755',
  }

  file { '/usr/local/mimecast/mimecast-web-container/resources/caps.schema.json':
    source => 'puppet:///modules/mimecast_web_container/resources/caps.schema.json',
  }

  file { '/usr/local/mimecast/mimecast-web-container/config/config.schema.json':
    source => 'puppet:///modules/mimecast_web_container/config/config.schema.json',
  }

  file { '/usr/local/mimecast/mimecast-web-container/resources/localproperties.schema.json':
    source => 'puppet:///modules/mimecast_web_container/resources/localproperties.schema.json',
  }

  file { '/usr/local/mimecast/mimecast-web-container/resources/admin-console.caps.schema.json':
    source => 'puppet:///modules/mimecast_web_container/resources/admin-console.caps.schema.json',
  }

  file { '/usr/local/mimecast/mimecast-web-container/resources/mimecast-web-container.app.schema.json':
    source => 'puppet:///modules/mimecast_web_container/resources/mimecast-web-container.app.schema.json',
  }

  file { '/usr/local/mimecast/mimecast-web-container/encryption.key':
    content   => base64('decode', $encryption_key),
    replace   => true,
    show_diff => false,
    require   => File['/usr/local/mimecast/mimecast-web-container']
  }


  file { '/usr/local/mimecast/mimecast-web-container/siging.key':
    content   => base64('decode', $siging_key),
    replace   => true,
    show_diff => false,
    require   => File['/usr/local/mimecast/mimecast-web-container'],
  }

  file { '/usr/local/mimecast/mimecast-web-container/public.key':
    source  => 'puppet:///modules/mimecast_web_container/scripts/public.key',
    replace => true,
    require => File['/usr/local/mimecast/mimecast-web-container'],
  }


  file { '/usr/local/mimecast/mimecast-web-container/private.key':
    source  => 'puppet:///modules/mimecast_web_container/scripts/private.key',
    require => File['/usr/local/mimecast/mimecast-web-container'],
  }

  file { '/usr/local/mimecast/mimecast-web-container/secret.key':
    source  => 'puppet:///modules/mimecast_web_container/scripts/secret.key',
    require => File['/usr/local/mimecast/mimecast-web-container'],
  }

  file { '/usr/local/mimecast/mimecast-web-container/cfg/config.json':
    ensure       => file,
    content      => template('mimecast_web_container/config.json.erb'),
    validate_cmd => '/usr/bin/python3 -m jsonschema -i % /usr/local/mimecast/mimecast-web-container/config/config.schema.json',
    replace      => true,
    require      => File['/usr/local/mimecast/mimecast-web-container/config/config.schema.json']
  }

  $serverjson_source = $::mc_servertype ? {
    'webservice' => 'webservice-server.json.erb',
    'webservice-alpha' => 'webservice-server.json.erb',
    default      => 'adcon-server.json.erb',
  }

  file { '/usr/local/mimecast/mimecast-web-container/cfg/server.json':
    content => template("mimecast_web_container/${serverjson_source}"),
    replace => false,
    require => File['/usr/local/mimecast/mimecast-web-container'],
  }

  file { '/usr/local/mimecast/mimecast-web-container/cfg/localproperties.json':
    source       => [
      "puppet:///modules/mimecast_web_container/scripts/${::mc_grid}/${::domain}/${::hostname}/localproperties.json",
      "puppet:///modules/mimecast_web_container/scripts/${::mc_grid}/${::domain}/${::mc_servertype}/localproperties.json",
      "puppet:///modules/mimecast_web_container/scripts/${::mc_grid}/${::domain}/localproperties.json",
      "puppet:///modules/mimecast_web_container/scripts/${::mc_grid}/${::hostname}/localproperties.json",
      "puppet:///modules/mimecast_web_container/scripts/${::mc_grid}/${::mc_servertype}/localproperties.json",
      "puppet:///modules/mimecast_web_container/scripts/${::mc_grid}/localproperties.json",
      "puppet:///modules/mimecast_web_container/scripts/${::mc_servertype}/localproperties.json",
      'puppet:///modules/mimecast_web_container/scripts/localproperties.json'
    ],
    validate_cmd => '/usr/bin/python3 -m jsonschema -i % /usr/local/mimecast/mimecast-web-container/resources/localproperties.schema.json',
    replace      => true,
    require      => File['/usr/local/mimecast/mimecast-web-container/resources/localproperties.schema.json'],
  }

  file { '/usr/local/mimecast/mimecast-web-container/cfg/log4j.xml':
    source  => [
      "puppet:///modules/mimecast_web_container/scripts/${::mc_grid}/${::domain}/${::hostname}/log4j.xml",
      "puppet:///modules/mimecast_web_container/scripts/${::mc_grid}/${::domain}/${::mc_servertype}/log4j.xml",
      "puppet:///modules/mimecast_web_container/scripts/${::mc_grid}/${::domain}/log4j.xml",
      "puppet:///modules/mimecast_web_container/scripts/${::mc_grid}/${::hostname}/log4j.xml",
      "puppet:///modules/mimecast_web_container/scripts/${::mc_grid}/${::mc_servertype}/log4j.xml",
      "puppet:///modules/mimecast_web_container/scripts/${::mc_grid}/log4j.xml",
      "puppet:///modules/mimecast_web_container/scripts/${::mc_servertype}/log4j.xml",
      'puppet:///modules/mimecast_web_container/scripts/log4j.xml'
    ],
    replace => true,
    require => File['/usr/local/mimecast/mimecast-web-container'],
  }


  file { '/usr/local/mimecast/mimecast-web-container/cfg/log4j2.xml':
    source  => [
      "puppet:///modules/mimecast_web_container/scripts/${::mc_grid}/${::domain}/${::hostname}/log4j2.xml",
      "puppet:///modules/mimecast_web_container/scripts/${::mc_grid}/${::domain}/${::mc_servertype}/log4j2.xml",
      "puppet:///modules/mimecast_web_container/scripts/${::mc_grid}/${::domain}/log4j2.xml",
      "puppet:///modules/mimecast_web_container/scripts/${::mc_grid}/${::hostname}/log4j2.xml",
      "puppet:///modules/mimecast_web_container/scripts/${::mc_grid}/${::mc_servertype}/log4j2.xml",
      "puppet:///modules/mimecast_web_container/scripts/${::mc_grid}/log4j2.xml",
      "puppet:///modules/mimecast_web_container/scripts/${::mc_servertype}/log4j2.xml",
      'puppet:///modules/mimecast_web_container/scripts/log4j2.xml'
    ],
    replace => true,
    require => File['/usr/local/mimecast/mimecast-web-container'],
  }


  file { '/usr/local/mimecast/mimecast-web-container/cfg/mimecast-admin-console.caps.json':
    source       => [
      "puppet:///modules/mimecast_web_container/scripts/${::mc_grid}/${::domain}/${::hostname}/mimecast-admin-console.caps.json",
      "puppet:///modules/mimecast_web_container/scripts/${::mc_grid}/${::domain}/${::mc_servertype}/mimecast-admin-console.caps.json",
      "puppet:///modules/mimecast_web_container/scripts/${::mc_grid}/${::domain}/mimecast-admin-console.caps.json",
      "puppet:///modules/mimecast_web_container/scripts/${::mc_grid}/${::hostname}/mimecast-admin-console.caps.json",
      "puppet:///modules/mimecast_web_container/scripts/${::mc_grid}/${::mc_servertype}/mimecast-admin-console.caps.json",
      "puppet:///modules/mimecast_web_container/scripts/${::mc_grid}/mimecast-admin-console.caps.json",
      "puppet:///modules/mimecast_web_container/scripts/${::mc_servertype}/mimecast-admin-console.caps.json",
      'puppet:///modules/mimecast_web_container/scripts/mimecast-admin-console.caps.json'
    ],
    validate_cmd => '/usr/bin/python3 -m jsonschema -i % /usr/local/mimecast/mimecast-web-container/resources/admin-console.caps.schema.json',
    replace      => true,
    require      => File['/usr/local/mimecast/mimecast-web-container/resources/admin-console.caps.schema.json'],
    #notify  => Service['mimecast-web-container'],
  }

  file { '/usr/local/mimecast/mimecast-web-container/cfg/mimecast-portal.caps.json':
    source       => [
      "puppet:///modules/mimecast_web_container/scripts/${::mc_grid}/${::domain}/${::hostname}/mimecast-portal.caps.json",
      "puppet:///modules/mimecast_web_container/scripts/${::mc_grid}/${::domain}/${::mc_servertype}/mimecast-portal.caps.json",
      "puppet:///modules/mimecast_web_container/scripts/${::mc_grid}/${::domain}/mimecast-portal.caps.json",
      "puppet:///modules/mimecast_web_container/scripts/${::mc_grid}/${::hostname}/mimecast-portal.caps.json",
      "puppet:///modules/mimecast_web_container/scripts/${::mc_grid}/${::mc_servertype}/mimecast-portal.caps.json",
      "puppet:///modules/mimecast_web_container/scripts/${::mc_grid}/mimecast-portal.caps.json",
      "puppet:///modules/mimecast_web_container/scripts/${::mc_servertype}/mimecast-portal.caps.json",
      'puppet:///modules/mimecast_web_container/scripts/mimecast-portal.caps.json'
    ],
    replace      => true,
    require      => File['/usr/local/mimecast/mimecast-web-container/resources/caps.schema.json'],
    validate_cmd => '/usr/bin/python3 -m jsonschema -i % /usr/local/mimecast/mimecast-web-container/resources/caps.schema.json',
  }

  file { '/usr/local/mimecast/mimecast-web-container/cfg/mimecast-reviewer.caps.json':
    source       => [
      "puppet:///modules/mimecast_web_container/scripts/${::mc_grid}/${::domain}/${::hostname}/mimecast-reviewer.caps.json",
      "puppet:///modules/mimecast_web_container/scripts/${::mc_grid}/${::domain}/${::mc_servertype}/mimecast-reviewer.caps.json",
      "puppet:///modules/mimecast_web_container/scripts/${::mc_grid}/${::domain}/mimecast-reviewer.caps.json",
      "puppet:///modules/mimecast_web_container/scripts/${::mc_grid}/${::hostname}/mimecast-reviewer.caps.json",
      "puppet:///modules/mimecast_web_container/scripts/${::mc_grid}/${::mc_servertype}/mimecast-reviewer.caps.json",
      "puppet:///modules/mimecast_web_container/scripts/${::mc_grid}/mimecast-reviewer.caps.json",
      "puppet:///modules/mimecast_web_container/scripts/${::mc_servertype}/mimecast-reviewer.caps.json",
      'puppet:///modules/mimecast_web_container/scripts/mimecast-reviewer.caps.json'
    ],
    validate_cmd => '/usr/bin/python3 -m jsonschema -i % /usr/local/mimecast/mimecast-web-container/resources/caps.schema.json',
    require      => File['/usr/local/mimecast/mimecast-web-container/resources/caps.schema.json'],
  }

  file { '/usr/local/mimecast/mimecast-web-container/cfg/mimecast-supervision.caps.json':
    source       => [
      "puppet:///modules/mimecast_web_container/scripts/${::mc_grid}/${::domain}/${::hostname}/mimecast-supervision.caps.json",
      "puppet:///modules/mimecast_web_container/scripts/${::mc_grid}/${::domain}/${::mc_servertype}/mimecast-supervision.caps.json",
      "puppet:///modules/mimecast_web_container/scripts/${::mc_grid}/${::domain}/mimecast-supervision.caps.json",
      "puppet:///modules/mimecast_web_container/scripts/${::mc_grid}/${::hostname}/mimecast-supervision.caps.json",
      "puppet:///modules/mimecast_web_container/scripts/${::mc_grid}/${::mc_servertype}/mimecast-supervision.caps.json",
      "puppet:///modules/mimecast_web_container/scripts/${::mc_grid}/mimecast-supervision.caps.json",
      "puppet:///modules/mimecast_web_container/scripts/${::mc_servertype}/mimecast-supervision.caps.json",
      'puppet:///modules/mimecast_web_container/scripts/mimecast-supervision.caps.json'
    ],
    validate_cmd => '/usr/bin/python3 -m jsonschema -i % /usr/local/mimecast/mimecast-web-container/resources/caps.schema.json',
    require      => File['/usr/local/mimecast/mimecast-web-container/resources/caps.schema.json'],
  }


  if $::operatingsystemmajrelease == '6' {
    $init_script = '/etc/init.d/mimecast-web-container'
    $owner = 'root'
  }
  else {
    file { '/etc/systemd/system/mimecast-web-container.service':
      ensure  => present,
      content => template('mimecast_web_container/mimecast-web-container.service.erb'),
      owner   => root,
      group   => root,
      mode    => 'u=rw-x,go=r-x',
      notify  => Exec['mimecast-web-container_reload_systemd'],
      before  => Service['mimecast-web-container'],
    }
    $init_script = '/usr/local/mimecast/mimecast-web-container/bin/mimecast-web-container'
    $owner = 'mcuser'
  }

  exec { 'mimecast-web-container_reload_systemd':
    command     => '/usr/bin/systemctl daemon-reload',
    refreshonly => true,
    notify      => Service['mimecast-web-container'],
  }

  file { $init_script:
    owner  => $owner,
    group  => $owner,
    mode   => '0755',
    source => [
      "puppet:///modules/mimecast_web_container/scripts/${::mc_grid}/${::domain}/${::hostname}/mimecast-web-container",
      "puppet:///modules/mimecast_web_container/scripts/${::mc_grid}/${::domain}/${::mc_servertype}/mimecast-web-container",
      "puppet:///modules/mimecast_web_container/scripts/${::mc_grid}/${::domain}/mimecast-web-container",
      "puppet:///modules/mimecast_web_container/scripts/${::mc_grid}/${::hostname}/mimecast-web-container",
      "puppet:///modules/mimecast_web_container/scripts/${::mc_grid}/${::mc_servertype}/mimecast-web-container",
      "puppet:///modules/mimecast_web_container/scripts/${::mc_grid}/mimecast-web-container",
      "puppet:///modules/mimecast_web_container/scripts/${::mc_servertype}/mimecast-web-container",
      'puppet:///modules/mimecast_web_container/scripts/mimecast-web-container'
    ]
  }

    file { "/usr/local/mimecast/mimecast-web-container/cfg/mimecast-admin-console.app.json":
      ensure       => file,
      content      => template('mimecast_web_container/mimecast-admin-console.app.json.erb'),
      validate_cmd => '/usr/bin/python3 -m jsonschema -i % /usr/local/mimecast/mimecast-web-container/resources/mimecast-web-container.app.schema.json',
      replace      => true,
      require      => File['/usr/local/mimecast/mimecast-web-container'],
      notify       => Service['mimecast-web-container'],
    }

  logrotation::worker { 'mimecast-web-container-logs':
    service                 => ['mimecast-web-container-log'],
    log_dir                 => ['/usr/local/mimecast/mimecast-web-container/log'],
    log_pattern_to_compress => ['*.log'],
    log_age_to_compress     => ['+2'],
    log_pattern_to_remove   => ['*.zst'],
    log_age_to_remove       => ['+90'],
  }

  $mcms_user = hiera('postgres_users')

  if $::mc_servertype == 'adcon' {

    file { '/usr/local/mimecast/mimecast-web-container/debug':
      ensure => directory,
    }

    file { '/usr/local/mimecast/mimecast-web-container/debug/adcon-web-ui.json':
      content => template('mimecast_web_container/adcon-web-ui.json.erb'),
      replace => true,
      require => File['/usr/local/mimecast/mimecast-web-container'],
    }


    if $::mc_publicsector == 'false' or $::mc_publicsector == false {
      #--------------- Browser Isolation client cert -------------------
      $adcon_biclient_cert_name    = 'adcon_biclient_cert'
      $adcon_biclient_cert         = hiera("adcon_biclient_cert_prod_${::mc_prodgrid}",{},'internal_certs')
      $adcon_biclient_cert_key      = $adcon_biclient_cert['key']
      $adcon_biclient_cert_crt      = $adcon_biclient_cert['crt']
      $adcon_biclient_cert_keystore_password = hiera('adcon_biclient_cert::keystore_password')

      pki_client::cert { 'adcon_biclient_cert':
        certname => 'adcon_biclient_cert',
        key      => $adcon_biclient_cert_key,
        crt      => $adcon_biclient_cert_crt,
        owner    => 'mcuser',
        group    => 'mcuser',
        key_dir  => '/usr/local/mimecast/mimecast-web-container/cfg/',
        crt_dir  => '/usr/local/mimecast/mimecast-web-container/cfg/',
      }
      -> java_ks { "${adcon_biclient_cert_name}.jks":
        ensure       => 'latest',
        trustcacerts => false,
        certificate  => "/usr/local/mimecast/mimecast-web-container/cfg/${adcon_biclient_cert_name}.crt",
        private_key  => "/usr/local/mimecast/mimecast-web-container/cfg/${adcon_biclient_cert_name}.key",
        target       => "/usr/local/mimecast/mimecast-web-container/cfg/${adcon_biclient_cert_name}.jks",
        password     => $adcon_biclient_cert_keystore_password,
        path         => ['/usr/java/latest/jre/bin/'],
      }

      file { "/usr/local/mimecast/mimecast-web-container/cfg/${adcon_biclient_cert_name}.jks":
        owner => 'mcuser',
        group => 'mcuser',
        mode  => '0400'
      }

      file { "/usr/local/mimecast/mimecast-web-container/cfg/.adcon_biclient_cert_password":
        ensure  => 'present',
        content => inline_template('<%= @adcon_biclient_cert_keystore_password %>'),
        owner   => 'root',
        group   => 'mcapp',
        mode    => '0440',
        require => Group['mcapp'],
      }
    }
  }

  if ($::mc_grid =~ /^(DEV|QA|SND|STG|LT|DE|ZA|UK|Jersey|CA|US|USB|USPGOV|USPCOM|AU)$/ or $::mc_alpha == 'true') {
    file { [
      '/usr/local/mimecast/mimecast-web-container/cfg/static',
      '/usr/local/mimecast/mimecast-web-container/tmp/event-streaming-service',
      '/usr/local/mimecast/mimecast-web-container/resources/event-streaming-service'
    ]:
      ensure => directory,
      mode   => '0755'
    }

    file { '/usr/local/mimecast/mimecast-web-container/resources/event-streaming-service/product-definition.schema.json':
      source => 'puppet:///modules/mimecast_web_container/resources/event-streaming-service/product-definition.schema.json',
    }

    file { '/usr/local/mimecast/mimecast-web-container/resources/event-streaming-service/products-definition.schema.json':
      source => 'puppet:///modules/mimecast_web_container/resources/event-streaming-service/products-definition.schema.json',
    }

    file { '/usr/local/mimecast/mimecast-web-container/resources/event-streaming-service/merge_product_definition.rb':
      source => 'puppet:///modules/mimecast_web_container/resources/event-streaming-service/merge_product_definition.rb',
    }

    file { '/usr/local/mimecast/mimecast-web-container/cfg/static/event-streaming-service':
      ensure  => directory,
      source  => ["puppet:///modules/mimecast_web_container/static/event-streaming-service"],
      recurse => true,
      purge   => true,
      validate_cmd => '/usr/bin/python3 -m jsonschema -i % /usr/local/mimecast/mimecast-web-container/resources/event-streaming-service/product-definition.schema.json',
      require      => File['/usr/local/mimecast/mimecast-web-container/resources/event-streaming-service/product-definition.schema.json'],
      notify       => Exec['merge_product_definition']
    }

    exec { 'merge_product_definition':
      refreshonly => true,
      cwd         => "/usr/local/mimecast/mimecast-web-container/cfg/static/event-streaming-service",
      provider    => shell,
      command     => "/usr/bin/ruby /usr/local/mimecast/mimecast-web-container/resources/event-streaming-service/merge_product_definition.rb",
      notify      => Exec['validate_copy_products_definition']
    }

    exec { 'validate_copy_products_definition':
      refreshonly => true,
      cwd         => "/usr/local/mimecast/mimecast-web-container/tmp/event-streaming-service",
      provider    => shell,
      command     => "/usr/bin/python3 -m jsonschema -i ./products_definition.json   /usr/local/mimecast/mimecast-web-container/resources/event-streaming-service/products-definition.schema.json && cp products_definition.json /usr/local/mimecast/mimecast-web-container/cfg/static"
    }
  }
}
