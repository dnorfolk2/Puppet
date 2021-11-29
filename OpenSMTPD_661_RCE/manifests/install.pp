class opensmtpd_661::install {

    Exec { 
        path    => [ '/bin/', '/sbin/' , '/usr/bin/', '/usr/sbin/' ], 
        environment => [ 'http_proxy=172.22.0.51:3128', 'https_proxy=172.22.0.51:3128' ], 
    }

    exec { 'set-nic-dhcp':
        command => 'sudo dhclient ens3',
        notify  => Exec['set-sed'],
        logoutput => true,
    }

    exec { 'set-sed': 
        command => "sudo sed -i 's/172.33.0.51/172.22.0.51/g' /etc/systemd/system/docker.service.d/* /etc/environment /etc/apt/apt.conf /etc/security/pam_env.conf", 
    }

    # Install LibreSSL from source tar
    file { '/usr/local/src/libressl-3.4.1.tar.gz':
        owner  => root,
        group  => root,
        mode   => '0775',
        ensure => file,
        source => '/usr/local/src/libressl-3.4.1.tar.gz',
        notify => Exec['unpack_libressl'],
    }

    exec { 'unpack_libressl':
        cwd     => '/usr/local/src',
        command => 'tar xzvf libressl-3.4.1.tar.gz',
        creates => '/usr/local/src/libressl-3.4.1/',
        notify  => Exec['install_libressl'],
    }

    ensure_packages(['build-essential', 'gcc'])
    
    exec { 'install_libressl':
        cwd     => '/usr/local/src/libressl-3.4.1/',
        command => '/usr/local/src/libressl-3.4.1/configure',
        notify  => Exec['make_libressl'],
        require => Package['build-essential', 'gcc'],
    }

    exec { 'make_libressl' :
        require => Exec['install_libressl'],
        cwd     => '/usr/local/src/libressl-3.4.1/',
        command => '/usr/bin/make',
        notify  => Exec['make_install_libressl'],
    }

    exec { 'make_install_libressl':
        require => Exec['install_libressl'],
        cwd     => '/usr/local/src/libressl-3.4.1/',
        command => '/usr/bin/make install',
        notify  => File['/usr/local/src/opensmtpd-6.6.1p1.tar.gz'],
    }

    # Install OpenSMTPD from source tar
    file { '/usr/local/src/opensmtpd-6.6.1p1.tar.gz':
        owner  => root,
        group  => root,
        mode   => '0775',
        ensure => file,
        source => '/usr/local/src/opensmtpd-6.6.1p1.tar.gz',
        notify => Exec['unpack_opensmtpd'],
    }

    exec { 'unpack_opensmtpd':
        cwd     => '/usr/local/src',
        command => 'tar xzvf opensmtpd-6.6.1p1.tar.gz',
        creates => '/usr/local/src/rce_opensmtpd_6.6.1/',
        notify  => Exec['install_opensmtpd'],
    }

    ensure_packages(['build-essential', 'gcc', 'libasr0', 'libasr-dev', 'libevent-dev', 'zlib1g-dev', 'bison'])

    exec { 'install_opensmtpd':
        cwd     => '/usr/local/src/rce_opensmtpd_6.6.1/',
        command => '/usr/local/src/rce_opensmtpd_6.6.1/configure',
        notify  => Exec['make_opensmtpd'],
        require => Package['build-essential', 'gcc', 'libasr0', 'libasr-dev', 'libevent-dev', 'zlib1g-dev', 'bison'],
    }

    exec { 'make_opensmtpd' :
        require => Exec['install_opensmtpd'],
        cwd     => '/usr/local/src/rce_opensmtpd_6.6.1/',
        command => '/usr/bin/make',
        notify  => Exec['make_install_opensmtpd'],
    }

    exec { 'make_install_opensmtpd':
        require => Exec['install_opensmtpd'],
        cwd     => '/usr/local/src/rce_opensmtpd_6.6.1/',
        command => '/usr/bin/make install',
        notify  => Exec['restart-networking'],
    }

    # Restart Networking
    exec { 'restart-networking':
        command => 'service networking restart',
        require => Exec['build-ftpserver'],
        notify  => File['/opt/pachev_ftp/pachev_ftp-master/ftp_server/target/release/conf'],
    }

    # Cleanup
    exec { 'directory-cleanup':
        command => '/bin/rm /usr/local/src/* -rf',
    }
}
