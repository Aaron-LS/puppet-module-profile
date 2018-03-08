class profile::base {

    include ntp
    class { 'motd':
      template => 'profile/welcomeMessage.erb',
    }

    group { 'lsadmin':
      ensure => present,
      gid    => '200',
      system => true,
    }

    class { 'sudo':
      purge               => false,
      config_file_replace => false,
    }

    sudo::conf { 'lsadmins':
      priority => 10,
      ensure  => present,
      content  => "%lsadmins ALL=(ALL) NOPASSWD: ALL",
    }
  
    sudo::conf { 'ubuntu':
      priority => 10,
      content  => "ubuntu ALL=(ALL) NOPASSWD: ALL",
    }
    
    profile::utils::addsudouser { 'aws_abutler':
     username => 'abutler',
     uid      => '5007',
     ssh_key_content => 'AAAAB3NzaC1yc2EAAAADAQABAAACAQDM9B9yUNdlydOEZ2uzgcDKb4hOFxlVds/1QZ5a7UG97QXXw0OyIEHp5jhCWmG75BKt2DEmFTdVvflAo801x+sAywlKM52c3O76bhnYCb9UTbMUSMGx3lfimbeGxbs8y4tNbpP6luKWkvxy+AMPhhAfTId+oUZeRGV53QwbCDDjHwl+oHzLAJ0PtW+X8yRnjFLmaESQeFRjLeKAFQ635vqT7QwdikiPaxrIlrH79Z9akq4LusBG/+m90mKjHDGPsWQnqGjTJCAG3NAqO8CvJo3X/to/WCg3IIvGbwXMihM+DDCDzfOVU/VS7fLr10T+n7jjjhe5OxTCUix7ntHBm2EQom1z0ka+kmKKSQpQUMuJ1PSmUzYUIl0HkgaNCY03zL2VsRKFiHQ48DJ4Hez8MhrKquuFJYY6pHTKmiraqXalbNtL2cX39hY5jbkz2PnthfJOFb/J+Drt2E5Swj6FUUDM8RpOdfQEtyif41xb3jt28W237qSIQg8IgAodK4aOf71CC7R+DK6q/plbdz+cP7ZB+l7zsr1PD0xHu5xJaq4aKBqPMpe6rM9AuIGIvMBdeoSQ3XciazByrKidIf5l5wmrBz/ztn2K3u2JvGLoCpuEaNorAGpIKTNk/8WRt5E7Ath4r1ogo4n6+6kPEk7iQ6m9oqmakURktdDe7JjARv5hZw==',
    }
    
    profile::utils::addsudouser { 'aws_sberthelot':
     username => 'sberthelot',
     uid      => '5010',
     ssh_key_content => 'AAAAB3NzaC1yc2EAAAADAQABAAACAQDvcGtSdjZP9msVKMGrl3tIgThZEkq4jFKXEs1C/5BxIsdPNQ4yOyhHpXtT1OJtxxI8bm9x7qw60QxbIHox3Q0GtGdQjex7sMnde6BxmMWH/J/0RTA3d1tjJZCoKnvAzqSfxenRCcTaqmKSupGciW8Z7kFuJziR3ncpkHQHD60VYVYisafKyy5nF7raooJPox4gY2HYHgwpmi+8d1bgiKDMQyDapMs8Xe/+K5saG2zOG7nVXd0l2A9ybTAzRufbK1yyZthnTPvJb1Hg6oBipBonCpnSdrxxMUl8U6Axr116XMdPRTdyH0MVX+CwW/zBWRbxRE+0A/WmH2EPXtcRTXfBvQ9mWLl01pk3YtYCdffH7eSIexJAg23qM4w+RVZk/Z1pGcGB+3m8JfMz3jSgvIW3GBx2IVeudRBn36DgT8rGGJ4/8Sz6OKYNgBFpM1gA3qtO74avux+1z/Fy5xpPPyiYYvonN4z9kaqRt2f/c5GW3XHurTK7pmJKi9ohhUqodYeKSnyjQi3hCP+JpAu+bWqawAiBGah7Blzq5x1MK16c4cuqRpWCQ9uw9fKHTPCGhfngT6IkeZdMO4yOKSdWUHZQf8bZNJ0KaOx//kXULo2aJvI2CTOe6iTIhdL1dI6f/DYGLX6g24hChKAA8bFRCu+GAeN9/+CxJ4dQisReXYd7qw==',
    }
    
    user { 'testtwo':
      ensure          => absent,
    }
    
    user { 'testuser':
      ensure          => absent,
    }
}
