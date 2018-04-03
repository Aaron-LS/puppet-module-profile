class profile::mysql {
    
    class {'::mysql::server':
      package_name     => 'mariadb-server',
      service_name     => 'mysql',
      root_password    => '*3929D05C6D847F751BA50F59C4F6BC69A74EAF83',
      override_options => {
        mysqld => {
          'log-error' => '/var/log/mysql/mariadb.log',
          'pid-file'  => '/var/run/mysqld/mysqld.pid',
        },
        mysqld_safe => {
          'log-error' => '/var/log/mysql/mariadb.log',
        },
      }
    }

    class {'::mysql::client':
      package_name    => 'mariadb-client',
      bindings_enable => true,
    }
}

class profile::mysql::production inherits profile::mysql {
  
  mysql::db { "${facts['networking']['hostname']}prod":
    user     => "${facts['networking']['hostname']}prod",
    password => "${facts['networking']['hostname']}2018LS",
    host     => 'localhost',
    grant    => ['SELECT', 'UPDATE'],
  }
  
  mysql::db { "${facts['networking']['hostname']}qa":
    user     => "${facts['networking']['hostname']}qa",
    password => "${facts['networking']['hostname']}qa2018LS",
    host     => 'localhost',
    grant    => ['SELECT', 'UPDATE'],
  }

}



