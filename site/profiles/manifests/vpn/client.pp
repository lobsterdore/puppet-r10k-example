# OpenVPN client setup
# Keys should be copied to server before puppet runs
# Requires that dnsmasq be installed and running
class profiles::vpn::client (
    $remote
) {
    package { 'openvpn':
        ensure  => present,
        require => [
            Service['dnsmasq'],
        ],
    } ->
    file { '/etc/openvpn/keys':
        ensure => directory,
        owner  => 'root',
        group  => 'root',
        mode   => '0400',
    } ->
    file { "/etc/openvpn/${::fqdn}.conf":
        ensure  => present,
        owner   => 'root',
        group   => 'root',
        mode    => '0600',
        content => template('profiles/vpn/client.conf.erb'),
    } ~>
    service { 'openvpn':
        ensure    => running,
        name      => "openvpn@${::fqdn}",
        hasstatus => true,
        enable    => true,
        subscribe => [
            Service['dnsmasq'],
        ],
    }

    # Accept all via vpn
    firewall { '200 accept input via VPN':
        chain   => 'INPUT',
        iniface => 'tun+',
        action  => 'accept',
        proto   => 'all',
    }

    firewall { '201 accept input via VPN':
        chain   => 'FORWARD',
        iniface => 'tun+',
        action  => 'accept',
        proto   => 'all',
    }
}
