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

    sudo::conf { 'lsadmin':
      priority => 10,
      ensure  => present,
      content  => "%lsadmin ALL=(ALL) NOPASSWD: ALL",
    }
  
    sudo::conf { 'ubuntu':
      priority => 10,
      content  => "ubuntu ALL=(ALL) NOPASSWD: ALL",
    }
    
    profile::utils::addsudouser { 'aws_abutler':
     username => 'abutler',
     uid      => '5007',
     ssh_key_content => 'AAAAB3NzaC1yc2EAAAADAQABAAACAQCkEju00pt9nFDjznGVtLkwAVJori8BibeYhTKiQhDrs/TW6ia+zEtpXa2qIn1KD8unQkn0sQlG39WMuvfM9zpp4tDwI8Iq1N796XJd8KeSQryOiwcVqERLr+70uCZgW5GyviYBWF7Bc5kYQVWfzFKEpogxsAHyRuxOXVLWGPIKaGQeyLrwwSTpB7OGEN1wL1gTXssRjqZx6Q460IJ64D7lR7fSJvlpZZedSbxgBRFPuJOPG80Fy7dAq94AXuhY1kQlKUnhT2CJFWaF6giVjzpijXFxzEpCC+20xyz5L6p4FWyQ7/mAlZqbLOQnT4WmbBTE1M/0rb0CXSNwm4ppsu+PB6MlOLYzBcQ7xiwR+IlJlkZHlzEihtCdr0NFyFJW2s29OJTCRsC741oT4OX5Hyo4DztO8aFeq6fdpZVB1yAV91vF1sxS8MeHToyy33l8jMW70F+NQ95hZqVLzLfW1o8AfYFf+OWI7CHtuTFWVkuU3pxgEOLyRtGgKGBgQCb+7+IfushO/fdCcVqdmauUgRyeFUg1gpGqcqvm/2ztnhIcYJaJHd1I3IzX641j4kGMlEy2SQKxWB4ktkz8ERaQKhoA9HqoYaVGR2cCk4p/ptFTCbjAb2JOHG8VR/AdEwUPkuCIILkKNeEOYMcJoWN3ff7w5ttJGHeFXJ1Bzwrs5TmivQ==',
    }
    
    profile::utils::addsudouser { 'aws_sberthelot':
     username => 'sberthelot',
     uid      => '5010',
     ssh_key_content => 'AAAAB3NzaC1yc2EAAAADAQABAAACAQDQHlcTYmKoiD5NmBVrWfR6L6rPI29o5XtIHEjpbWMmgJfpEmZKTxC5gldz344Jnpa4l2yn9+bLBNzyGPW7dFLr6xJ5A60DnrfxmzU98KBtYXzQq/Bjsg+nLA7yEeVhtGWLdkLrrXS+LT48FGXdF9x1ejw4pLu6wMg0cGE5nz2pb+NrNp6YGNnc1Dh+mVnp/AsCZmjC6shDbnedu2QoQpFTUM1yF9uYufEcduVExfDuH+9P+lwffE5zzDNDUU9XiG6kTFHDBFV2d6HS6IWGqct563CD2TCop53gZSTQB/3h0b91eBa857KTffXoKsXYx4Rgm4r9zCIMAJVZZYPuQNky/JjpZI48z7DqKGqwD6pQ/ipZqrElXVTXsZrrb96UzI8SUAeykfSHFJ1F34og5u7hB2t8ScPzEhMu/zns59rb5KhUgmEzGLG5Kz4W67B7Y0h6xN7tLRliaTH7InkZQal0EDrqrcWM1rjLikhZQas2W63KEEuH07fRmIo+LjSu1XTUgvDmnfh/0ePyKANGS27g0E0tsV992xY+FBEvjff6fSwZXQ5cNjKYrBLnCkVyqa6gtf1c1WaHXs/yjlxM1CZdw9dbQ+dKE8FKLxD5REClCUWTMpawEVXRKjQnfglGnPf8bxgZ5me2GvQNVpa3rYd5KlFSz8W1JMDEPwu1NFrUIQ==',
    }

}
