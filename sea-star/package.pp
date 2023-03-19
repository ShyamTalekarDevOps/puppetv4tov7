#
class mimecast_sea_star_server_toolkit::package {

  # Install applications prior to the toolkit
  package { 'mimecast-sea-star-server-toolkit': } 
  -> package { 'mimecast-ttp-web-portal': }
  -> package { 'mimecast-swg-web-portal': }

  package { 'mimecast-office-addin':
    ensure => 'present',
  }

  package { 'threat-dashboard':
    ensure => 'present',
  }

  package { 'cloud-protect-dashboard':
    ensure => 'present',
  }

  # Confining this to DEV it is only promoted to that grid and was causing puppet errors across production
  if $::mc_grid =~ /^(DEV|DEVRH|QA|STG|LT|CA|ZA)$/ {
  package { 'ingestion-management':
    ensure => 'present',
  }
  }

  package { 'mimecast-at-phishing-web-portal':
    ensure => 'present',
  }

  package { 'mimecast-bi-web-portal':
    ensure => 'present',
  }

  package { 'matfe':
    ensure => 'present',
  }

  package { 'connect':
    ensure => 'present',
  }

  if $::mc_grid == 'DEV' {
    package { 'mimecast-sync-recover':
      ensure => 'present',
    }
  }

  if $::mc_grid =~ /^(DEV|QA)$/ {
    package { 'mateup':
      ensure => 'present',
    }
  }

  package { 'onboarding':
    ensure => 'present',
  }

  package { 'supervision':
    ensure => 'present',
  }

  package { 'mimecast-case-review':
    ensure => 'present',
  }

}
