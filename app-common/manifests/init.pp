#
class mimecast_app_common {
  class { '::mimecast_app_common::packages': }
  -> class { '::mimecast_app_common::conf': }
  -> class { '::mimecast_app_common::service': }
  -> class { '::mimecast_app_common::cron': }
}
