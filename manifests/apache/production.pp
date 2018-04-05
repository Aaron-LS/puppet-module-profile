class profile::apache::production  {
  class { '::profile::apache::install' : } -> class { 'profile::apache::setup' :}  
}

class profile::apache::setup {
  $server_hostname = "${facts['networking']['hostname']}"
  class { '::apache':
    default_vhost => false,
  }
  
  # Exaple parameter usage:
  apache::mod { 'pagespeed':
    rewrite_level => 'PassThrough',
    enable_filters => [
      'combine_javascript', 'convert_meta_tags', 'extend_cache'
    ]
  }
  # Vhost to redirect non-ssl to ssl using old rewrite method
  apache::vhost { 'non-ssl':
    vhost_name   => '*',
    docroot      => '/var/www/first',
    priority     => '10',
    port         => '80',
    rewrite_cond => '%{HTTPS} off',
    rewrite_rule => '(.*) https://%{HTTP_HOST}%{REQUEST_URI}',
  }

  # SSL vhost at the same domain
  apache::vhost { 'ssl-prod':
    servername     => "${server_hostname}.legal-suite.com",
    vhost_name     => '*',
    port           => '443',
    docroot        => '/var/www/first',
    ssl            => true,
    proxy_pass => [
      {
        'path' => '/',
        'url'  => 'http://localhost:8080/',
        'params'   => {
          'retry'   => '10',
          },
      },
    ],
  }
  
  # SSL vhost at the same domain
  apache::vhost { 'ssl-qa':
    servername     => "${server_hostname}-qa.legal-suite.com",
    vhost_name     => '*',
    port           => '443',
    docroot        => '/var/www/first',
    ssl            => true,
    proxy_pass => [
      {
        'path' => '/',
        'url'  => 'http://localhost:8081/',
        'params'   => {
          'retry'   => '10',
          },
      },
    ],
  }
  
}
