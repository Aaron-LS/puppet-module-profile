class profile::tomcat::production {

  tomcat::install { '/opt/tomcat8':
    source_url => 'https://www.apache.org/dist/tomcat/tomcat-8/v8.5.29/bin/apache-tomcat-8.5.29.tar.gz'
  }
  tomcat::instance { 'tomcat8Prod':
    catalina_home => '/opt/tomcat8',
    catalina_base => '/opt/tomcat8Prod',
  }
  tomcat::instance { 'tomcat8QA':
    catalina_home => '/opt/tomcat8',
    catalina_base => '/opt/tomcat8QA',
  }
  # Change the default port of the second instance server and HTTP connector
  tomcat::config::server { 'tomcat8QA':
    catalina_base => '/opt/tomcat8QA',
    port          => '8006',
  }
  
  tomcat::config::server::tomcat_users {
  'role-manager-script-Prod':
    ensure        => present,
    catalina_base => '/opt/tomcat8Prod',
    element       => 'role',
    element_name  => 'manager-script';
  'role-probeuser-Prod':
    ensure        => present,
    catalina_base => '/opt/tomcat8Prod',
    element       => 'role',
    element_name  => 'probeuser';
  'role-poweruser-Prod':
    ensure        => present,
    catalina_base => '/opt/tomcat8Prod',
    element       => 'role',
    element_name  => 'poweruser';
  'role-poweruserplus-Prod':
    ensure        => present,
    catalina_base => '/opt/tomcat8Prod',
    element       => 'role',
    element_name  => 'poweruserplus';
  'role-manager-gui-Prod':
    ensure        => present,
    catalina_base => '/opt/tomcat8Prod',
    element       => 'role',
    element_name  => 'manager-gui';
  'user-admin-Prod':
    ensure        => present,
    catalina_base => '/opt/tomcat8Prod',
    element       => 'user',
    element_name  => 'admin',
    password      => 'vtgn3fdh',
    roles         => ['manager-gui','probeuser','poweruser','powerusersplus'];
  'user-legalsuite-Prod':
    ensure        => present,
    catalina_base => '/opt/tomcat8Prod',
    element       => 'user',
    element_name  => 'legalsuite',
    password      => 'ls',
    roles         => ['probeuser'];
  }
  
  tomcat::config::server::tomcat_users {
  'role-manager-script-QA':
    ensure        => present,
    catalina_base => '/opt/tomcat8QA',
    element       => 'role',
    element_name  => 'manager-script';
  'role-probeuser-QA':
    ensure        => present,
    catalina_base => '/opt/tomcat8QA',
    element       => 'role',
    element_name  => 'probeuser';
  'role-poweruser-QA':
    ensure        => present,
    catalina_base => '/opt/tomcat8QA',
    element       => 'role',
    element_name  => 'poweruser';
  'role-poweruserplus-QA':
    ensure        => present,
    catalina_base => '/opt/tomcat8QA',
    element       => 'role',
    element_name  => 'poweruserplus';
  'role-manager-gui-QA':
    ensure        => present,
    catalina_base => '/opt/tomcat8QA',
    element       => 'role',
    element_name  => 'manager-gui';
  'user-admin-QA':
    ensure        => present,
    catalina_base => '/opt/tomcat8QA',
    element       => 'user',
    element_name  => 'admin',
    password      => 'vtgn3fdh',
    roles         => ['manager-gui','probeuser','poweruser','powerusersplus'];
  'user-legalsuite-QA':
    ensure        => present,
    catalina_base => '/opt/tomcat8QA',
    element       => 'user',
    element_name  => 'legalsuite',
    password      => 'ls',
    roles         => ['probeuser'];
  }
  
  
  tomcat::config::server::connector { 'tomcat8QA-http':
    catalina_base         => '/opt/tomcat8QA',
    port                  => '8081',
    protocol              => 'HTTP/1.1',
    additional_attributes => {
      'redirectPort' => '8443'
    },
  }
  
  tomcat::war { 'LSProbeProd':
    war_name      => 'LSProbe.war',
    catalina_base => '/opt/tomcat8Prod',
    war_source    => 'puppet:///modules/profile/LSProbe.war',
  }
  
  tomcat::war { 'LSProbeQA':
    war_name      => 'LSProbe.war',
    catalina_base => '/opt/tomcat8QA',
    war_source    => 'puppet:///modules/profile/LSProbe.war',
  }
}
