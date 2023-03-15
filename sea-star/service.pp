#
class mimecast_sea_star_server_toolkit::service(
  $ensure = 'running',
) {

  service { 'mimecast-sea-star-server-toolkit':
    ensure     => $ensure,
    hasstatus  => true,
    enable     => false,
    hasrestart => true,
  }

  # 1. Check if sea-star is running (and alive)
  # 2. Check node exists
  # 3. If the node on disk is not the node that sea-star is running against, restart it.
  #    => This implies that node has been upgraded.
  exec { 'restart sea-star for node upgrade':
    command => '/sbin/service mimecast-sea-star-server-toolkit restart',
    onlyif  => '/bin/echo "/sbin/service mimecast-sea-star-server-toolkit status &>/dev/null && ls /usr/bin/node &>/dev/null && lsof -p $(cat /var/run/mimecast-sea-star-server-toolkit.pid) | grep -q \'node (deleted)\'" | /bin/bash',
  }

}
