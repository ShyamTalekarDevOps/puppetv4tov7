# 
class mimecast_web_container {
  class { '::mimecast_web_container::package': }
  -> class { '::mimecast_web_container::config': }
  -> class { '::mimecast_web_container::apps_config': }
  -> class { '::mimecast_web_container::service': }

  logrotation::worker { 'mimecast-web-container-tmp':
    service                 => ['mimecast-web-container'],
    log_dir                 => ['/usr/local/mimecast/mimecast-web-container/tmp'],
    log_pattern_to_compress => ['*.log'],
    log_age_to_compress     => ['+3'],
    log_pattern_to_remove   => ['*.tmp'],
    log_age_to_remove       => ['+60'],
  }
}
