class profile::postfix {
    
    
}

class profile::postfix::production inherits profile::postfix {
  
  package { 'postfix':
    ensure => 'installed',
  }
  $server_hostname = "${facts['networking']['hostname']}"
  $hostnames = "${server_hostname}.legal-suite.com, ${server_hostname}, ${server_hostname}-qa.legal-suite.com, ${server_hostname}-qa, localhost"
  
  file_line { 'mydestination':
    ensure => present,
    path   => '/etc/postfix/main.cf',
    line   => "mydestination = ${$hostnames}",
    match  => 'mydestination = ',
    notify => Service['postfix']
  } 

  file_line { 'myhostname':
    ensure => present,
    path   => '/etc/postfix/main.cf',
    line   => "myhostname = $server_hostname.legal-suite.com",
    match  => 'myhostname = ',
    notify => Service['postfix']
  } 
  
  service {'postfix' :
    ensure => running,
  }
  
  
}



