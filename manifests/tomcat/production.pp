class profile::tomcat::installTomcat {
  tomcat::install { '/opt/tomcat8':
    source_url => 'https://www.apache.org/dist/tomcat/tomcat-8/v8.5.29/bin/apache-tomcat-8.5.29.tar.gz'
  }

}

class profile::tomcat::production inherits profile::tomcat::installTomcat {

  profile::tomcat::config { 'Prod' :
    tomcat_service_name       => 'tomcat8Prod',
    tomcat_install_location   => '/opt/tomcat8Prod',
  }

  profile::tomcat::config { 'QA' :
    tomcat_service_name       => 'tomcat8QA',
    tomcat_install_location   => '/opt/tomcat8QA',
    tomcat_server_port        => '8006',
    tomcat_connector_port     => '8081',
  }

}