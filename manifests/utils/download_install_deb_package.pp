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

  $package_path = "/opt/${package_real}"
  exec { 'download':
    command  => "wget ${url}",
    path => '/usr/bin:/usr/sbin:/bin:/usr/local/bin',
    cwd      => '/opt',
    user     => 'root',
    creates  => "${package_path}",
    notify   => Exec['install']
  }

  exec {'install':
    command => "dpkg -i ${package_path}",
    path    => ['/usr/local/sbin', '/usr/local/bin', '/usr/sbin', '/usr/bin', '/sbin', '/bin'],
    refreshonly  => true,
    notify   => Exec['install2']
  }

  exec {'install2':
    command => "sudo apt-get install -f",
    path    => ['/usr/local/sbin', '/usr/local/bin', '/usr/sbin', '/usr/bin', '/sbin', '/bin'],
    refreshonly  => true,
  }

}