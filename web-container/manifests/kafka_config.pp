#
class mimecast_web_container::kafka_config {

  # Overriding the lookup by mc_grid in hiera to force US in our SWGPOP environment
  # TODO: we should reorganise the keys in hiera to be able to avoid this workaround
  if ( $::mc_swgpop == 'true' and $::mc_grid =~ /^(USC|USW)$/ ) {
    $kafka_brokers = hiera('zookeeper::servers', {}, 'kafka/US')
  } else {
    $kafka_brokers = hiera('zookeeper::servers', {}, "kafka/${::mc_grid}")
  }

  $app_user = 'mcuser'
  $app_group = 'mcuser'
  $ulm = '/usr/local/mimecast/mimecast-web-container/cfg'
  $kafka_brokers_port = '9092'

  file { "${ulm}/kafka.json":
    ensure  => file,
    content => template('mimecast_web_container/kafka.json.erb'),
    owner   => $app_user,
    group   => $app_group,
    mode    => '0644',
  }

}
