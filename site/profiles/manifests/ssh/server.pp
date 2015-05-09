# Sets ssh config for all instances
class profiles::ssh::server {
    package { 'ssh':
        ensure => present,
    } ->
    file { '/etc/ssh/sshd_config':
        ensure  => present,
        owner   => 'root',
        group   => 'root',
        mode    => '0600',
        content => file( 'profiles/ssh/sshd_config'),
    } ~>
    service { 'ssh':
        ensure     => running,
        hasstatus  => true,
        hasrestart => true,
        enable     => true,
    }
}
