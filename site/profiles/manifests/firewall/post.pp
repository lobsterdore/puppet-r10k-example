# Last in firewall rules
class profiles::firewall::post {
    firewall { '998 drop all':
        chain  => 'INPUT',
        proto  => 'all',
        action => 'drop',
        before => undef,
    }

    firewall { '999 drop all':
        chain  => 'FORWARD',
        proto  => 'all',
        action => 'drop',
        before => undef,
    }
}
