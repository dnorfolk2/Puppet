class opensmtpd_661_RCE::install {

    # Install LibreSSL from source tar

    file { '/usr/local/src/libressl-3.4.1.tar.gz':
        owner  => root,
        group  => root,
        mode   => '0775',
        ensure => file,
        source => 'puppet:///modules/opensmtpd_661_RCE/libressl-3.4.1.tar.gz',
        notify => Exec['unpack_libressl'],
    }

    exec { 'unpack_libressl':
        cwd     => '/usr/local/src',
        command => 'tar -xzvf libressl-3.4.1.tar.gz',
        creates => '/usr/local/src/libressl-3.4.1/',
        path    => [ '/bin/', '/sbin/' , '/usr/bin/', '/usr/sbin/' ],
        notify  => Exec['install_libressl'],
    }

    ensure_packages('build-essential')
    ensure_packages('gcc')
    
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
        source => 'puppet:///modules/opensmtpd_661_RCE/opensmtpd-6.6.1p1.tar.gz',
        notify => Exec['unpack_opensmtpd'],
    }

    exec { 'unpack_opensmtpd':
        cwd     => '/usr/local/src',
        command => 'tar -xzvf opensmtpd-6.6.1p1.tar.gz',
        creates => '/usr/local/src/rce_opensmtpd_6.6.1/',
        path    => [ '/bin/', '/sbin/' , '/usr/bin/', '/usr/sbin/' ],
        notify  => Exec['install_opensmtpd'],
    }

    ensure_packages('build-essential')
    ensure_packages('gcc')
    ensure_packages('libasr0')
    ensure_packages('libasr-dev')
    ensure_packages('libevent-dev')
    ensure_packages('zlib1g-dev')
    ensure_packages('bison')


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
    }

    # Add some stuff up here!

    # Cleanup
    
    exec { 'directory-cleanup':
        command => '/bin/rm /usr/local/src/* -rf',
    }
}
