class profile::apache::production  {
  class { '::profile::apache::install' : } -> class { 'profile::apache::setup' :}  
}

class profile::apache::setup {
  $server_hostname = "${facts['networking']['hostname']}"
  class { '::apache':
    default_vhost => false,
    mpm_module => false,
  }
  
  class { '::apache::mod::event':
    startservers            => '2',
    minsparethreads         => '32',
    maxsparethreads         => '128',
    threadlimit             => '64',
    threadsperchild         => '64',
    maxrequestworkers       => '192',
    maxconnectionsperchild  => '4096', 
  }
  
  class { '::apache::mod::proxy':
    proxy_requests => 'Off',
    
  }
  class { '::apache::mod::proxy_http':
    
  }
  class { '::apache::mod::proxy_ajp':
  
  }
  
  
  # Exaple parameter usage:
  class { '::apache::mod::pagespeed':
    rewrite_level => 'PassThrough',
    enable_filters => [
      'combine_javascript','convert_meta_tags','extend_cache','fallback_rewrite_css_urls','flatten_css_imports','inline_css','inline_import_to_link','inline_javascript','rewrite_css','rewrite_images','rewrite_javascript','rewrite_style_attributes_with_url','collapse_whitespace','elide_attributes','trim_urls','remove_comments','remove_quotes','insert_image_dimensions,sprite_images,lazyload_images,dedup_inlined_images','rewrite_style_attributes','move_css_to_head','move_css_above_scripts','extend_cache_pdfs','insert_dns_prefetch'
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
    ssl_protocol   => 'all -SSLv3 -TLSv1 -TLSv1.1',
    ssl_cipher     => 'ECDHE-ECDSA-AES256-GCM-SHA384:ECDHE-RSA-AES256-GCM-SHA384:ECDHE-ECDSA-CHACHA20-POLY1305:ECDHE-RSA-CHACHA20-POLY1305:ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES128-GCM-SHA256:ECDHE-ECDSA-AES256-SHA384:ECDHE-RSA-AES256-SHA384:ECDHE-ECDSA-AES128-SHA256:ECDHE-RSA-AES128-SHA256',
    ssl_honorcipherorder => 'On',
    proxy_pass => [
      {
        'path' => '/',
        'url'  => 'http://localhost:8080/',
        'params'   => {
          'retry'     => '10',
          'min'       => '10',
          'max'       => '50', 
          'ttl'       => '120', 
          'keepalive' => 'on',
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
          'retry'     => '10',
          'min'       => '10',
          'max'       => '50', 
          'ttl'       => '120', 
          'keepalive' => 'on',
          },
      },
    ],
  }
  
}
