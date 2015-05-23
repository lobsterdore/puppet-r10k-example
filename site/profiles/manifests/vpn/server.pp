# Sets up OpenVPN server
# Keys should be copied to server before puppet
class profiles::vpn::server {
    $openvpn_config = hiera_hash('openvpn')
    # Arrange config for client_config files
    $client_configs  = $openvpn_config['client-configs']
    $client_config_keys = keys($client_configs)
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
    profiles::vpn::client_config {
        $client_config_keys:
            config       => $client_configs;
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

    firewall { '200 VPN allow tun input':
        chain   => 'INPUT',
        proto   => 'all',
        action  => 'accept',
        iniface => 'tun+'
    }

    firewall { '201 VPN allow tun forward':
        chain   => 'FORWARD',
        proto   => 'all',
        action  => 'accept',
        iniface => 'tun+'
    }

    firewall { '202 VPN server allow client connections via 1194':
        port   => '1194',
        proto  => 'udp',
        action => 'accept',
    }
}
