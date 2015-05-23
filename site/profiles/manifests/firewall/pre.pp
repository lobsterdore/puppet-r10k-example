# First off, basic firewall rules
class profiles::firewall::pre {
    Firewall {
      require => undef,
    }

    # Default firewall rules
    firewall { 'accept all icmp':
        proto  => 'icmp',
        action => 'accept',
    }

    firewall { 'accept all to lo interface':
        proto   => 'all',
        iniface => 'lo',
        action  => 'accept',
    }

    firewall { 'reject local traffic not on loopback interface':
        iniface     => '! lo',
        proto       => 'all',
        destination => '127.0.0.1/8',
        action      => 'reject',
    }

    firewall { 'accept related established rules':
        proto  => 'all',
        state  => ['RELATED', 'ESTABLISHED'],
        action => 'accept',
    }

    firewall { 'ssh 22':
        port   => '22',
        proto  => 'tcp',
        action => 'accept',
    }
}
