class transmission_daemon {
  include transmission_daemon::params

  $config = $transmission_daemon::params::config
  $packages = $transmission_daemon::params::packages
  $service = $transmission_daemon::params::service
  $download_dir = $transmission_daemon::params::download_dir
  $utp_enabled = $transmission_daemon::params::utp_enabled

  package { $packages :
    ensure => 'latest',
  }

  file { "${config}-new" :
    path => "${config}-new",
    ensure => 'present',
    mode => '0644',
    owner => 'root',
    group => 'root',
    content => template('transmission_daemon/settings.json.erb'),
  }

  file { $download_dir :
    path => $download_dir,
    ensure => 'directory',
    owner => 'debian-transmission',
    group => 'debian-transmission',
  }

  exec { "${service}-reload" :
    command => "service ${service} stop ; cp ${config}-new ${config} ; service ${service} start",
    provider => 'shell',
    user => 'root',
    refreshonly => true,
  }

  Class['dpkg'] ->
    Package[$packages] ->
    File["${config}-new"] ->
    File[$download_dir] ~>
    Exec["${service}-reload"]

  File["${config}-new"] ~>
    Exec["${service}-reload"]
}