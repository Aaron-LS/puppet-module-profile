define profile::utils::download_install_deb_package (
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

  exec {'install':
    command => "dpkg -i ${package_path}",
    path    => ['/usr/local/sbin', '/usr/local/bin', '/usr/sbin', '/usr/bin', '/sbin', '/bin', '/usr/games', '/usr/local/games'],
  }

  exec {'install2':
    command => "sudo apt-get install -f",
    path    => ['/usr/local/sbin', '/usr/local/bin', '/usr/sbin', '/usr/bin', '/sbin', '/bin', '/usr/games', '/usr/local/games'],
  }

  file {'cleanup':
    ensure => absent,
    path   => "${package_path}",
  }

  Exec['download'] -> Exec['install'] -> Exec['install2'] -> File['cleanup']

}