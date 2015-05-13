# Configure dnsmasq
class profiles::dns::client {
    package { 'dnsmasq':
        ensure => present,
    } ->
    file { '/etc/dnsmasq.conf':
        ensure  => present,
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
        content => file('profiles/dns/dnsmasq.conf'),
    } ~>
    service { 'dnsmasq':
        ensure     => running,
        hasstatus  => true,
        hasrestart => true,
        enable     => true,
    }
}
