class freeftpd::install {
  file { 'C:\Users\vagrant\Downloads\freeftpd.exe':
    ensure => present,
    source => 'puppet:///modules/freeftpd/freeftpd.exe',
   } ->

   package { "freeftpd":
     ensure => installed,
     source => 'C:\Users\vagrant\Downloads\freeftpd.exe',
     install_options => ['/sAll']
   }

   exec { 'set_as_services':
    command => '"C:\Program Files (x86)\freeFTPd\FreeFTPDService.exe" /service',
  }
}
