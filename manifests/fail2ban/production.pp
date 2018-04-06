class profile::fail2ban::production  {

  package { 'fail2ban':
    ensure => installed,
  }
  
  
}