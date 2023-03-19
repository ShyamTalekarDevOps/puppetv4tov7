#
class mimecast_login::docroot (
  $base_dir,
  $vhost_fqdn,
  $htdocs) {
  file { $base_dir:
    ensure => directory,
    mode   => '0755',
    owner  => 'nginx',
    group  => 'nginx',
  }
  file { "${base_dir}/${vhost_fqdn}":
    ensure => directory,
    mode   => '0755',
    owner  => 'nginx',
    group  => 'nginx',
  }
  file { "${base_dir}/${vhost_fqdn}/${htdocs}":
    ensure => directory,
    mode   => '0755',
    owner  => 'nginx',
    group  => 'nginx',
  }
}
