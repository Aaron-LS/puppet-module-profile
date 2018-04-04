class profile::apache::production  {
  $server_hostname = "${facts['networking']['hostname']}",
  class { 'apache': }
    
  # Vhost to redirect non-ssl to ssl using old rewrite method
  apache::vhost { 'non-ssl':
    vhost_name   => '*',
    port         => '80',
    rewrite_cond => '%{HTTPS} off',
    rewrite_rule => '(.*) https://%{HTTP_HOST}%{REQUEST_URI}',
  }
    
  # Vhost with SSLProtocol,SSLCipherSuite, SSLHonorCipherOrder
  
  # SSL vhost at the same domain
  apache::vhost { 'first.example.com ssl':
    servername           => "${server_hostname}.legal-suite.com",
    vhost_name           => '*',
    port       => '443',
    docroot    => '/var/www/first',
    ssl        => true,
  }
  

  
  
}
