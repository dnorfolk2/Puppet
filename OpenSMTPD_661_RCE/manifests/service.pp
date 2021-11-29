class opensmtpd_661::service {
    exec { 'run_smtpd':
        ensure  => File['/etc/mailer.conf'],
        ensure  => File['/etc/smtpd.conf']
        command => '/usr/sbin/smtpd',
    }
}
