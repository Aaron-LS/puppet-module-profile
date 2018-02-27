class profile::base {

    include ntp
    class { 'motd':
      template => 'puppet-module-profile/welcomeMessage.erb',
    }

}
