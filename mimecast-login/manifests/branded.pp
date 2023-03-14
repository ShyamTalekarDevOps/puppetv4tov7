#
# Deploy Certificates
#
class mimecast_login::branded (
  $ensure    = 'present',
  $owner     = 'root',
  $group     = 'root',
) {
    $pki_dir = '/etc/pki/reverse-proxy'
    $cert = hiera('wildcard_login-je_mimecast-offshore_com')

    file { "${pki_dir}/login-je.mimecast-offshore.com.key":
      ensure  => $ensure,
      owner   => $owner,
      group   => $group,
      replace => true,
      mode    => '0400',
      content => $cert['key'],
    }

    file { "${pki_dir}/login-je.mimecast-offshore.com.pem":
      ensure  => $ensure,
      owner   => $owner,
      group   => $group,
      replace => true,
      mode    => '0444',
      content => $cert['crt'],
    }

}
