
define profile::utils::addsudouser(
  $username        = undef,
  $uid             = undef,
  $gid             = 'lsadmin',
  $home            = "/home/$username",
  $shell           = '/bin/bash',
  $password        = '$1$gFsqPtNw$Gv7mb7rmKlhKLrvada64W1',
  $ensure          = present,
  $system          = true,
  $managehome      = true,
  $purge_ssh_keys  = true,
  $ssh_key_name    = "default_$username",
  $ssh_key_type    = 'ssh-rsa',
  $ssh_key_content = undef,
) {

  user { $username:
    uid             => $uid,
    gid             => $gid,
    home            => $home,
    shell           => $shell,
    password        => $password,
    ensure          => $ensure,
    system          => $system,
    managehome      => $managehome,
    purge_ssh_keys  => $purge_ssh_keys,
  }

  ssh_authorized_key { $ssh_key_name:
    ensure => present,
    user   => $username,
    type   => $ssh_key_type,
    key    => $ssh_key_content,
  }

  sudo::conf { $username:
    priority => 10,
    content  => "$username ALL=(ALL) NOPASSWD: ALL",
  }

}