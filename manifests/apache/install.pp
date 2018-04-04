class profile::apache::install  {
  
  url-package {'freight':
    url      => 'https://dl-ssl.google.com/dl/linux/direct/mod-pagespeed-stable_current_amd64.deb',
    provider => 'dpkg',
  }  
}

define profile::tomcat::download_deb_pacakge (
  $url,
  $provider,
  $package = undef,
) {

  if $package {
    $package_real = $package
  } else {
    $package_real = $title
  }

  $package_path = "/tmp/${package_real}"

  exec {'download':
    command => "/usr/bin/wget -O ${package_path} ${url}"
  }

  package {'install':
    ensure   => installed,
    name     => "${package}",
    provider => 'dpkg',
    source   => "${package_path}",
  }

  file {'cleanup':
    ensure => absent,
    path   => "${package_path}",
  }

  Exec['download'] -> Package['install'] -> File['cleanup']

}