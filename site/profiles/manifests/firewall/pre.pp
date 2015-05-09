# First off, basic firewall rules
class profiles::firewall::pre {
    Firewall {
      require => undef,
    }

    # Default firewall rules
    firewall { '000 accept all icmp':
        proto  => 'icmp',
        action => 'accept',
    }

    firewall { '001 accept all to lo interface':
        proto   => 'all',
        iniface => 'lo',
        action  => 'accept',
    }

    firewall { '002 reject local traffic not on loopback interface':
        iniface     => '! lo',
        proto       => 'all',
        destination => '127.0.0.1/8',
        action      => 'reject',
    }

    firewall { '003 accept related established rules':
        proto  => 'all',
        state  => ['RELATED', 'ESTABLISHED'],
        action => 'accept',
    }

    # Accept all via vpn
    firewall { '004 accept input via VPN':
        chain   => 'INPUT',
        iniface => 'tun+',
        action  => 'accept',
        proto   => 'all',
    }

    firewall { '005 accept input via VPN':
        chain   => 'FORWARD',
        iniface => 'tun+',
        action  => 'accept',
        proto   => 'all',
    }

    if $::vagrant == 1 {
        # Allow standard ssh if running in Vagrant
        firewall { '006 ssh 22':
            port   => '22',
            proto  => 'tcp',
            action => 'accept',
        }
    }
}
