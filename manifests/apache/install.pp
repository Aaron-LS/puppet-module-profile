class profile::apache::install  {
  profile::utils::download_install_deb_package {'mod-pagespeed-stable_current_amd64.deb':
    url      => 'https://dl-ssl.google.com/dl/linux/direct/mod-pagespeed-stable_current_amd64.deb',
    provider => 'dpkg',
  }
}



