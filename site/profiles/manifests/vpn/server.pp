# Sets up OpenVPN server
# Keys should be copied to server before puppet
class profiles::vpn::server {
    package { 'openvpn':
        ensure => present
    } ->
    file { '/etc/openvpn/keys':
        ensure => directory,
        owner  => 'root',
        group  => 'root',
        mode   => '0400',
    } ->
    file { '/etc/openvpn/client-configs':
        ensure => directory,
        owner  => 'root',
        group  => 'root',
        mode   => '0666',
    } ->
    profiles::vpn::client_config { 'dummy.techpunch.com':
        ips     => '10.8.0.100 10.8.0.101'
    } ->
    profiles::vpn::client_config { 'home-computer':
        ips     => '10.8.0.104 10.8.0.105'
    } ->
    file { "/etc/openvpn/${::fqdn}.conf":
        ensure  => present,
        owner   => 'root',
        group   => 'root',
        mode    => '0600',
        content => template('profiles/vpn/server.conf.erb'),
    } ~>
    service { 'openvpn':
        ensure    => running,
        name      => "openvpn@${::fqdn}",
        hasstatus => true,
        enable    => true,
    }

    # Firewall rules

    firewall { '201 VPN allow tun input':
        chain   => 'INPUT',
        proto   => 'all',
        action  => 'accept',
        iniface => 'tun+'
    }

    firewall { '202 VPN allow tun forward':
        chain   => 'FORWARD',
        proto   => 'all',
        action  => 'accept',
        iniface => 'tun+'
    }

    firewall { '203 VPN server allow client connections via 1194':
        port   => '1194',
        proto  => 'udp',
        action => 'accept',
    }

    firewall { '204 VPN server masquerade outgoing vpn traffic':
        table    => 'nat',
        chain    => 'POSTROUTING',
        outiface => 'eth0',
        source   => '10.8.0.0/24',
        jump     => 'MASQUERADE',
        proto    => 'all',
    }
}
