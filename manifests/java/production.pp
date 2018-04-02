class profile::java::production {
  
  class { 'java':
    distribution => 'jre',
    package => 'openjdk-8-jdk',
  }
  
}