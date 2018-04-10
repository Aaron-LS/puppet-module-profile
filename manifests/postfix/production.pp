class profile::postfix {
    
    
}

class profile::posffix::production inherits profile::postfix {
  
  package { 'postfix':
    ensure => 'installed',
  }
  $server_hostname = "${facts['networking']['hostname']}"
  $hostnames = "${server_hostname}.legal-suite.com, ${server_hostname}, ${server_hostname}-qa.legal-suite.com, ${server_hostname}-qa, localhost"
  
  file_line { 'mydestination':
    ensure => present,
    path   => '/etc/postfix/main.cf',
    line   => "mydestination =  ${$hostnames}",
    match  => 'mydestination = ',
  } 

}



