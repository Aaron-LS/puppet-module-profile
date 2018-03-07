class profile::base {

    include ntp
    class { 'motd':
      template => 'profile/welcomeMessage.erb',
    }
    
    user { 'abutler':
      uid             => '5007',
      gid             => '1000',
      home            => '/home/abutler',
      shell           => '/bin/bash',
      password        => '$1$gFsqPtNw$Gv7mb7rmKlhKLrvada64W1',
      ensure          => present,
      system          => true,
      managehome      => true,
      purge_ssh_keys  => true,
    }
    
    ssh_authorized_key { 'aws':
      ensure => present,
      user   => 'abutler',
      type   => 'ssh-rsa',
      key    => 'AAAAB3NzaC1yc2EAAAADAQABAAACAQDM9B9yUNdlydOEZ2uzgcDKb4hOFxlVds/1QZ5a7UG97QXXw0OyIEHp5jhCWmG75BKt2DEmFTdVvflAo801x+sAywlKM52c3O76bhnYCb9UTbMUSMGx3lfimbeGxbs8y4tNbpP6luKWkvxy+AMPhhAfTId+oUZeRGV53QwbCDDjHwl+oHzLAJ0PtW+X8yRnjFLmaESQeFRjLeKAFQ635vqT7QwdikiPaxrIlrH79Z9akq4LusBG/+m90mKjHDGPsWQnqGjTJCAG3NAqO8CvJo3X/to/WCg3IIvGbwXMihM+DDCDzfOVU/VS7fLr10T+n7jjjhe5OxTCUix7ntHBm2EQom1z0ka+kmKKSQpQUMuJ1PSmUzYUIl0HkgaNCY03zL2VsRKFiHQ48DJ4Hez8MhrKquuFJYY6pHTKmiraqXalbNtL2cX39hY5jbkz2PnthfJOFb/J+Drt2E5Swj6FUUDM8RpOdfQEtyif41xb3jt28W237qSIQg8IgAodK4aOf71CC7R+DK6q/plbdz+cP7ZB+l7zsr1PD0xHu5xJaq4aKBqPMpe6rM9AuIGIvMBdeoSQ3XciazByrKidIf5l5wmrBz/ztn2K3u2JvGLoCpuEaNorAGpIKTNk/8WRt5E7Ath4r1ogo4n6+6kPEk7iQ6m9oqmakURktdDe7JjARv5hZw==',
    }
}
