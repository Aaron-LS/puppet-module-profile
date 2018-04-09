class profile::fail2ban::production (
    String $publicips,
  ) {
    
  package { 'fail2ban':
    ensure => installed,
  }
  file { "/etc/fail2ban/jail.conf": # file destination
    content => epp('profile/fail2ban/jail.conf.epp', {}),
    owner    => root,
    group    => root,
    mode     => '0644',
  }
  
  file { "/etc/fail2ban/filter.d/modsec.conf": # file destination
    content => epp('profile/fail2ban/modsec.conf.epp', {}),
    owner    => root,
    group    => root,
    mode     => '0644',
  }

  file_line { 'publicips':
    ensure => present,
    path   => '/etc/fail2ban/jail.conf',
    line   => "ignoreip = 127.0.0.1/8 ${publicips}",
    match  => 'ignoreip = 127.0.0.1/8',
    notify   => Service['fail2ban']
  } 
  
  service { 'fail2ban':
    ensure => running,
    enable => true,
  }
}