class profile::mysql {
    class { '::mysql::server':
      root_password           => '*3929D05C6D847F751BA50F59C4F6BC69A74EAF83',
      remove_default_accounts => true,
      service_enabled         => true,
      override_options        => $override_options,

    }
}

class profile::mysql::production inherits profile::mysql {
  
  mysql::db { 'prod':
    user     => 'clientprod',
    password => 'mypass',
    host     => 'localhost',
    grant    => ['SELECT', 'UPDATE'],
  }
  
  mysql::db { 'qa':
    user     => 'clientqa',
    password => 'mypass',
    host     => 'localhost',
    grant    => ['SELECT', 'UPDATE'],
  }

}