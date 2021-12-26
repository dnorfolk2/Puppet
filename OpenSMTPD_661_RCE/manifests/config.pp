class opensmtpd_661::config {
  Exec { path => [ '/bin/', '/sbin/' , '/usr/bin/', '/usr/sbin/' ], environment => [ 'http_proxy=172.22.0.51:3128', 'https_proxy=172.22.0.51:3128' ] }

  # Create Users
  exec { 'mkdir_empty': command => "mkdir /var/empty", notify => Exec['create_user_smtpd'] } ->
  user { "${user}":
    ensure     => present,
    uid        => '666',
    gid        => 'root',
    home       => "/var/empty",
    managehome => true,
    password   => 'toor',
  } ->
  user { "${user}":
    ensure     => present,
    uid        => '666',
    gid        => 'root',
    home       => "/var/empty",
    managehome => true,
    password   => 'toor',
  } ->

  # Create directory for the flag
  file { '/root/flag':
    ensure  => directory,
    owner   => 'root',
    mode    => '0755',
    require => User['root'],
  } ->

  # Create flag file
  file { '/root/flag/flag.txt':
    ensure  => present,
    source  => '/usr/local/src/flag.txt',
    owner   => 'root',
    mode    => '0755',
    require => File['/root/flag'],
  } ->

  # Create Conf files
  file { '/etc/mailer.conf':
    ensure  => present,
    source  => '/usr/local/src/mailer.conf',
    owner   => 'root',
    mode    => '0755',
    notify  => Exec['run_smtpd'],
  }

  file { '/etc/smtpd.conf':
    ensure  => present,
    source  => '/usr/local/src/smtpd.conf',
    owner   => 'root',
    mode    => '0755',
    notify  => Exec['run_smtpd'],
  }
}
