class opensmtpd_661::config {
    Exec { path => [ '/bin/', '/sbin/' , '/usr/bin/', '/usr/sbin/' ], environment => [ 'http_proxy=172.22.0.51:3128', 'https_proxy=172.22.0.51:3128' ] }
    $secgen_parameters = secgen_functions::get_parameters($::base64_inputs_file)
    #$raw_org = $secgen_parameters['organisation']
    $leaked_filenames = $secgen_parameters['/opt/pachev_ftp/pachev_ftp-master/ftp_server/target/release/conf/users.cfg', '/home/ftpusr/pachev_ftp/flag.txt']
    $strings_to_leak = $secgen_parameters['/opt/pachev_ftp/pachev_ftp-master/ftp_server/target/release/conf/users.cfg maybe?']
    $strings_to_pre_leak = $secgen_parameters['/opt/pachev_ftp/pachev_ftp-master/ftp_server/target/release/ftproot/ftpusr/hint_file.txt']

    # ::secgen_functions::leak_files { 'proftpd_133c_backdoor-file-leak':
    #     storage_directory => '/root',
    #     leaked_filenames  => $leaked_filenames,
    #     strings_to_leak   => $strings_to_leak,
    #     leaked_from       => "proftpd_133c_backdoor",
    #     mode              => '0600'
    # }

    # Create Users
    exec { 'mkdir_empty': command => "mkdir /var/empty", notify => Exec['create_user_smtpd'] } ->
    exec { 'create_user_smtpd': ensure => Exec['mkdir_empty'], command => "useradd -c 'SMTP Daemon' -d /var/empty -s /sbin/nologin _smtpd" } ->
    exec { 'create_user_smtpq': ensure => Exec['mkdir_empty'], command => "useradd -c 'SMTPD Queue' -d /var/empty -s /sbin/nologin _smtpq" } ->

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
