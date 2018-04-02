class profile::tomcat::production {

  class { 'java': }

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
  tomcat::config::server::connector { 'tomcat8QA-http':
    catalina_base         => '/opt/tomcat8QA',
    port                  => '8081',
    protocol              => 'HTTP/1.1',
    additional_attributes => {
      'redirectPort' => '8443'
    },
  }
    

}
