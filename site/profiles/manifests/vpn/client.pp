# OpenVPN client setup
# Keys should be copied to server before puppet runs
# Requires that dnsmasq be installed and running
class profiles::vpn::client {
    $openvpn_config = hiera('openvpn')
    $remote = $openvpn_config['remote']
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

    # Firewall rules

    firewall { '201 allow tun input':
        chain   => 'INPUT',
        proto   => 'all',
        action  => 'accept',
        iniface => 'tun+'
    }

    firewall { '202 allow tun forward':
        chain   => 'FORWARD',
        proto   => 'all',
        action  => 'accept',
        iniface => 'tun+'
    }
}
