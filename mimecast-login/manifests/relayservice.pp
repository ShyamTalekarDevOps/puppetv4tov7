#
# Deploy Certificates
#
class mimecast_login::relayservice (
  $ensure    = 'present',
  $owner     = 'root',
  $group     = 'root',
){
  $pki_dir = '/etc/pki/reverse-proxy'
  case $::mc_grid {
      'DEVRH': {
        # this really should have its own cert. Prod certs shouldnt be in dev
        $cert = hiera(regsubst("wildcard.therelayserviceusps.com", '\.', '_', 'G'))
      }
      default: {
        $cert = hiera(regsubst("wildcard.${::mc_publicdomain_phishing}", '\.', '_', 'G'))
      }
  }
  if $::mc_publicsector == true or $::mc_publicsector == 'true'
  {
    file { "${pki_dir}/wildcard.therelayserviceusps.key":
      ensure  => $ensure,
      owner   => $owner,
      group   => $group,
      replace => true,
      mode    => '0400',
      content => $cert['key'],
    }

    file { "${pki_dir}/wildcard.therelayserviceusps.pem":
      ensure  => $ensure,
      owner   => $owner,
      group   => $group,
      replace => true,
      mode    => '0444',
      content => $cert['crt'],
    }
  }
  else
  {
    file { "${pki_dir}/wildcard.at-eu.therelayservice.key":
        ensure  => $ensure,
        owner   => $owner,
        group   => $group,
        replace => true,
        mode    => '0400',
        content => $cert['key'],
    }
    file { "${pki_dir}/wildcard.at-eu.therelayservice.pem":
      ensure  => $ensure,
      owner   => $owner,
      group   => $group,
      replace => true,
      mode    => '0444',
      content => $cert['crt'],
    }
  }
}
