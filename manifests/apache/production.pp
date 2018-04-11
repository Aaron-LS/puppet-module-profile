class profile::apache::production  {
  class { '::profile::apache::install' : } -> class { 'profile::apache::setup' :}  
  $serverSSL_dirs = [ "/var/lib/apache2/ssl" ]
  file { $serverSSL_dirs:
    ensure => 'directory',
    owner  => 'root',
    group  => 'root',
    mode   => '0400',
  }
  
  file { "/var/lib/apache2/ssl/legal-suite.crt": # file destination
        source   => 'puppet:///modules/profile/legal-suite.crt',
        owner    => root,
        group    => root,
        mode     => '0400',
  }

  file { "/var/lib/apache2/ssl/legal-suite.key": # file destination
        source   => 'puppet:///modules/profile/legal-suite.key',
        owner    => root,
        group    => root,
        mode     => '0400',
  }

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
  
  apache::custom_config { 'Cookies':
    filename => 'Cookies.conf',
    content  => 'Header edit Set-Cookie ^(.*)$ $1;HttpOnly;Secure',
  }
  
  apache::custom_config { 'ClickJacking':
    filename => 'ClickJacking.conf',
    content  => 'Header always append X-Frame-Options SAMEORIGIN',
  }
  
  class { '::apache::mod::proxy':
    proxy_requests => 'Off',
    
  }
  class { '::apache::mod::proxy_http':
    
  }
  class { '::apache::mod::proxy_ajp':
  
  }
  
  class { '::apache::mod::headers':
  
  }
  
  class { '::apache::mod::expires':
  
  }
  
  class { '::apache::mod::security':
    modsec_secruleengine => 'On',
    audit_log_relevant_status => undef,
    activated_rules           => [ '/usr/share/modsecurity-crs/base_rules/modsecurity_35_bad_robots.data', '/usr/share/modsecurity-crs/base_rules/modsecurity_35_scanners.data', '/usr/share/modsecurity-crs/base_rules/modsecurity_40_generic_attacks.data', '/usr/share/modsecurity-crs/base_rules/modsecurity_50_outbound.data', '/usr/share/modsecurity-crs/base_rules/modsecurity_50_outbound_malware.data', '/usr/share/modsecurity-crs/base_rules/modsecurity_crs_20_protocol_violations.conf', '/usr/share/modsecurity-crs/base_rules/modsecurity_crs_23_request_limits.conf', '/usr/share/modsecurity-crs/base_rules/modsecurity_crs_35_bad_robots.conf', '/usr/share/modsecurity-crs/base_rules/modsecurity_crs_40_generic_attacks.conf', '/usr/share/modsecurity-crs/base_rules/modsecurity_crs_41_sql_injection_attacks.conf', '/usr/share/modsecurity-crs/base_rules/modsecurity_crs_41_xss_attacks.conf', '/usr/share/modsecurity-crs/base_rules/modsecurity_crs_42_tight_security.conf', '/usr/share/modsecurity-crs/base_rules/modsecurity_crs_45_trojans.conf', '/usr/share/modsecurity-crs/base_rules/modsecurity_crs_47_common_exceptions.conf', '/usr/share/modsecurity-crs/base_rules/modsecurity_crs_48_local_exceptions.conf.example', '/usr/share/modsecurity-crs/base_rules/modsecurity_crs_49_inbound_blocking.conf', '/usr/share/modsecurity-crs/base_rules/modsecurity_crs_59_outbound_blocking.conf'],
  }
  
  class { '::apache::mod::pagespeed':
    rewrite_level => 'PassThrough',
    enable_filters => [
      'combine_javascript','convert_meta_tags','extend_cache','fallback_rewrite_css_urls','flatten_css_imports','inline_css','inline_import_to_link','inline_javascript','rewrite_css','rewrite_images','rewrite_javascript','rewrite_style_attributes_with_url','collapse_whitespace','elide_attributes','trim_urls','remove_comments','remove_quotes','insert_image_dimensions,sprite_images,lazyload_images,dedup_inlined_images','rewrite_style_attributes','move_css_to_head','move_css_above_scripts','extend_cache_pdfs','insert_dns_prefetch'
    ]
  }
  
  file_line { 'ServerSignature':
    ensure => present,
    path   => '/etc/apache2/conf-enabled/security.conf',
    line   => "ServerSignature Off",
    match  => 'ServerSignature On',
    notify   => Service['apache2']
  } 
  
  file_line { 'ServerTokens':
    ensure => present,
    path   => '/etc/apache2/conf-enabled/security.conf',
    line   => "ServerTokens ProductOnly",
    match  => 'ServerTokens OS',
    notify   => Service['apache2']
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
    ssl_cert => '/var/lib/apache2/ssl/legal-suite.crt',
    ssl_key  => '/var/lib/apache2/ssl/legal-suite.key',
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
    directories => [
    {
        path => '.*\.cache\..*',
        provider => 'locationmatch',
        custom_fragment => '
    ModPagespeed Off

    Header Unset Cache-Control

    ExpiresDefault "now plus 1 year"

    Header Set Cache-Control "max-age=31536000"
    ',
      },
    ]
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
        'path' => '/QA',
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
