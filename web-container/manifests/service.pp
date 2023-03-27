#
# Abatista, removing subscribed keystores as those are moving to puppet v7
class mimecast_web_container::service {
  service { 'mimecast-web-container':
    ensure     => running,
    hasrestart => true,
    enable     => false,
    hasstatus  => true,
    # subscribe  => File['/usr/local/mimecast/keystore'],
  }
}
