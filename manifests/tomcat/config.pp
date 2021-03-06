define profile::tomcat::config (
    $tomcat_service_name       = 'tomcat8',
    $tomcat_install_location   = '/opt/tomcat8',
    $tomcat_server_port        = '8005',
    $tomcat_connector_port     = '8080',
    $tomcat_memory_xmx         = '4G',
    $tomcat_memory_xms         = '4G',
  ) {
  file { "/etc/systemd/system/${tomcat_service_name}.service": # file destination
        content  => epp('profile/tomcat/tomcat.service.epp', {
                                 'catalinaHome' => '/opt/tomcat8',
                                 'catalinaBase' => "${tomcat_install_location}",
                                 'tomcatUser'   => 'tomcat',
                                 'tomcatGroup'  => 'tomcat',
                           }),
        owner    => root,
        group    => root,
        mode     => '0644',
  }
  
  file { "${tomcat_install_location}/bin/setenv.sh": # file destination
        content => epp('profile/tomcat/setenv.sh.epp', {
                                 'xms' => "${tomcat_memory_xmx}",
                                 'xmx' => "${tomcat_memory_xms}",
                           }),
        owner    => tomcat,
        group    => tomcat,
        mode     => '0644',
  }
  
  tomcat::instance { "${tomcat_service_name}":
    catalina_home          => '/opt/tomcat8',
    catalina_base          => "${tomcat_install_location}",
    user                   => 'tomcat',
    group                  => 'tomcat',
    manage_user            => true,
    manage_group           => true,
    manage_service         => false,
    manage_base            => true,
    manage_properties      => true,
    java_home              => '/usr/lib/jvm/java-1.8.0-openjdk-amd64/jre',
    use_jsvc               => false,
    use_init               => false,
  }
  
  # Change the default port of the second instance server and HTTP connector
  tomcat::config::server { "${tomcat_service_name}":
    catalina_base => "${tomcat_install_location}",
    port          => "$tomcat_server_port",
  }
  tomcat::config::server::connector { "${tomcat_service_name}":
    catalina_base         => "${tomcat_install_location}",
    port                  => "$tomcat_connector_port",
    protocol              => 'HTTP/1.1',
    purge_connectors      => true,
    additional_attributes => {
      'redirectPort' => '8443'
    },
  }
  
  tomcat::config::server::connector { "${tomcat_service_name}-apj-remove":
    catalina_base         => "${tomcat_install_location}",
    protocol              => 'AJP/1.3',
    connector_ensure      => 'absent',
  }


  tomcat::service { "${tomcat_service_name}":
    service_name   => "${tomcat_service_name}",
    catalina_home  => '/opt/tomcat8',
    catalina_base  => "${tomcat_install_location}",
    use_init       => true,
    user           => 'tomcat',
    service_ensure => 'running',
    service_enable => true,

  }

  tomcat::config::server::tomcat_users {
  "role-probeuser-${tomcat_service_name}":
    ensure        => present,
    catalina_base => "${tomcat_install_location}",
    element       => 'role',
    element_name  => 'probeuser';
  "role-poweruser-${tomcat_service_name}":
    ensure        => present,
    catalina_base => "${tomcat_install_location}",
    element       => 'role',
    element_name  => 'poweruser';
  "role-poweruserplus-${tomcat_service_name}":
    ensure        => present,
    catalina_base => "${tomcat_install_location}",
    element       => 'role',
    element_name  => 'poweruserplus';
  "role-manager-gui-${tomcat_service_name}":
    ensure        => present,
    catalina_base => "${tomcat_install_location}",
    element       => 'role',
    element_name  => 'manager-gui';
  "user-admin-${tomcat_service_name}":
    ensure        => present,
    catalina_base => "${tomcat_install_location}",
    element       => 'user',
    element_name  => 'admin',
    password      => 'vtgn3fdh',
    roles         => ['manager-gui','probeuser','poweruser','powerusersplus'];
  "user-legalsuite-${tomcat_service_name}":
    ensure        => present,
    catalina_base => "${tomcat_install_location}",
    element       => 'user',
    element_name  => 'legalsuite',
    password      => 'ls',
    roles         => ['probeuser'];
  }
    
  tomcat::war { "LSProbe${tomcat_service_name}":
    war_name      => 'LSProbe.war',
    catalina_base => "${tomcat_install_location}",
    war_source    => 'puppet:///modules/profile/LSProbe.war',
  }  
  
  $serverInfo_dirs = [ "${tomcat_install_location}/lib/org/",
                    "${tomcat_install_location}/lib/org/apache/", "${tomcat_install_location}/lib/org/apache/catalina/", 
                    "${tomcat_install_location}/lib/org/apache/catalina/util/"
                  ]

  
  file { $serverInfo_dirs:
    ensure => 'directory',
    owner  => 'tomcat',
    group  => 'tomcat',
    mode   => '0640',
  }
  
  file { "${tomcat_install_location}/lib/org/apache/catalina/util/ServerInfo.properties": # file destination
        content  => 'server.info=Application Server
server.number=unknown
server.built=unknown',
        owner    => tomcat,
        group    => tomcat,
        mode     => '0640',
  }
  
  tomcat::config::server::valve { "ErrorReportValve${tomcat_service_name}" :
    catalina_base         => "${tomcat_install_location}",
    class_name            => "org.apache.catalina.valves.ErrorReportValve",
    additional_attributes => {
      showReport     => "false",
      showServerInfo => "false"
    }

  }
  
}
