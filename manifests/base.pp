class profile::base {

    include ntp
    class { 'motd':
      template => 'profile/welcomeMessage.erb',
    }

}
