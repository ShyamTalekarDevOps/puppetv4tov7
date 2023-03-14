#
# Deploy Certificates
#
class mimecast_login::dhparam (
  $key_size = 4096,
  $location = '/etc/pki/reverse-proxy/dhparam4096.pem',
) {

  exec { 'generate dh param':
    command => "/usr/bin/openssl dhparam -out ${location} ${key_size}",
    creates => $location,
  }

}
