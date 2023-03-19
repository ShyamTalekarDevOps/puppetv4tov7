#
# Deploy Certificates
#
class mimecast_login::relayservice_usps (
  $ensure    = 'present',
  $owner     = 'root',
  $group     = 'root',
) {
  $pki_dir = '/etc/pki/reverse-proxy'
  $cert = hiera('wildcard_therelayserviceusps_com')

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
  if $::mc_grid == 'USPCOM' {
    $certname= 'asterisk.mimecast-pscom-us.com'
  }
  elsif $::mc_grid == 'USPGOV' {
    $certname= 'asterisk.mimecast-psgov-us.com'
  }
  else {
    $certname = "wildcard.${::mc_publicdomain}"
  }
  $certificate_lookup = regsubst("${certname}", '\.', '_', 'G')

  if $::mc_grid == 'THISISBREAKINGSHIT' {
    $cert2 = lookup($certificate_lookup,{},'webserver_keys')

    file { "${pki_dir}/${certname}.pem":
      ensure  => $ensure,
      owner   => $owner,
      group   => $group,
      replace => true,
      mode    => '0444',
      content => $cert2['crt'],
    }

    file { "${pki_dir}/${certname}.key":
      ensure  => $ensure,
      owner   => $owner,
      group   => $group,
      replace => true,
      mode    => '0400',
      content => $cert2['key'],
    }
  }
}
