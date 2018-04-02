class profile::java::production {
  
  java::oracle { 'jre8' :
  ensure  => 'present',
  version => '8',
  java_se => 'jre',
}
  
}