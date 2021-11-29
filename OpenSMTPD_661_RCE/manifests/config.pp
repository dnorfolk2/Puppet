class pachev_ftp_server_1_path_traversal::config {
    Exec { path => [ '/bin/', '/sbin/' , '/usr/bin/', '/usr/sbin/' ], environment => [ 'http_proxy=172.22.0.51:3128', 'https_proxy=172.22.0.51:3128' ] }
    $secgen_parameters = secgen_functions::get_parameters($::base64_inputs_file)
    #$raw_org = $secgen_parameters['organisation']
    $leaked_filenames = $secgen_parameters['/opt/pachev_ftp/pachev_ftp-master/ftp_server/target/release/conf/users.cfg', '/home/ftpusr/pachev_ftp/flag.txt']
    $strings_to_leak = $secgen_parameters['/opt/pachev_ftp/pachev_ftp-master/ftp_server/target/release/conf/users.cfg maybe?']
    $strings_to_pre_leak = $secgen_parameters['/opt/pachev_ftp/pachev_ftp-master/ftp_server/target/release/ftproot/ftpusr/hint_file.txt']

    # if $raw_org and $raw_org[0] and $raw_org[0] != '' {
    #     $organisation = parsejson($raw_org[0])
    # } else {
    #     $organisation = ''
    # }
    # file { '/etc/proftpd/proftpd.conf':
    #     ensure   => present,
    #     owner    => 'root',
    #     group    => 'root',
    #     mode     => '0644',
    #     content  => template('proftpd_133c_backdoor/proftpd.erb')
    # }

    # ::secgen_functions::leak_files { 'proftpd_133c_backdoor-file-leak':
    #     storage_directory => '/root',
    #     leaked_filenames  => $leaked_filenames,
    #     strings_to_leak   => $strings_to_leak,
    #     leaked_from       => "proftpd_133c_backdoor",
    #     mode              => '0600'
    # }

    # Create directory for the flag
    file { '/root/flag':
        ensure  => directory,
        owner   => 'root',
        mode    => '0755',
        require => User['root'],
        notify  => File['/root/flag/flag.txt'],
    }

    # Create flag file
    file { '/root/flag/flag.txt':
        ensure  => present,
        source  => '/home/unhcegila/puppet-modules/pachev_ftp_server_1_path_traversal/files/flag.txt',
        owner   => 'root',
        mode    => '0755',
        require => File['/root/flag'],
    }
}
