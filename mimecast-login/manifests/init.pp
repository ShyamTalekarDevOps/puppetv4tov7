class mimecast_login {
  class { '::mimecast_login::users': }
  -> class { '::mimecast_login::conf': }
  -> class { '::mimecast_login::dhparam': }
  -> class { '::mimecast_login::cron': }
}
