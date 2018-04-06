class profile::fail2ban::production (
    String $publicips,
  ) {
  
  $ipcommand = "sed -i '/ignoreip = 127.0.0.1\/8*/c\ignoreip = 127.0.0.1\/8 ${publicips}.' /etc/fail2ban/jail.conf"
  
  package { 'fail2ban':
    ensure => installed,
  }

  exec { 'publicips':
    command => $ipcommand,
    path    => ['/usr/local/sbin', '/usr/local/bin', '/usr/sbin', '/usr/bin', '/sbin', '/bin', '/usr/games', '/usr/local/games'],
  }
}
