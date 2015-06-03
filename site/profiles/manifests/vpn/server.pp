# Sets up OpenVPN server
# Keys should be copied to server before puppet
class profiles::vpn::server (
    $client_configs
) {
    #$openvpn_config = hiera_hash('openvpn')
    # Arrange config for client_config files
    #$client_configs  = $openvpn_config['client-configs']
    #$client_config_keys = keys($client_configs)
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

    create_resource(
        profiles::vpn::client_config,
        $client_configs
    )

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

    # Allow vpn clients to connect
    firewall { '203 VPN server allow client connections via 1194':
        port   => '1194',
        proto  => 'udp',
        action => 'accept',
    }
}
