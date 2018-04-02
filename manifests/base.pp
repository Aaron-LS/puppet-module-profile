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
     ssh_key_content => 'AAAAB3NzaC1yc2EAAAADAQABAAACAQDQHlcTYmKoiD5NmBVrWfR6L6rPI29o5XtIHEjpbWMmgJfpEmZKTxC5gldz344Jnpa4l2yn9+bLBNzyGPW7dFLr6xJ5A60DnrfxmzU98KBtYXzQq/Bjsg+nLA7yEeVhtGWLdkLrrXS+LT48FGXdF9x1ejw4pLu6wMg0cGE5nz2pb+NrNp6YGNnc1Dh+mVnp/AsCZmjC6shDbnedu2QoQpFTUM1yF9uYufEcduVExfDuH+9P+lwffE5zzDNDUU9XiG6kTFHDBFV2d6HS6IWGqct563CD2TCop53gZSTQB/3h0b91eBa857KTffXoKsXYx4Rgm4r9zCIMAJVZZYPuQNky/JjpZI48z7DqKGqwD6pQ/ipZqrElXVTXsZrrb96UzI8SUAeykfSHFJ1F34og5u7hB2t8ScPzEhMu/zns59rb5KhUgmEzGLG5Kz4W67B7Y0h6xN7tLRliaTH7InkZQal0EDrqrcWM1rjLikhZQas2W63KEEuH07fRmIo+LjSu1XTUgvDmnfh/0ePyKANGS27g0E0tsV992xY+FBEvjff6fSwZXQ5cNjKYrBLnCkVyqa6gtf1c1WaHXs/yjlxM1CZdw9dbQ+dKE8FKLxD5REClCUWTMpawEVXRKjQnfglGnPf8bxgZ5me2GvQNVpa3rYd5KlFSz8W1JMDEPwu1NFrUIQ==',
    }

}
