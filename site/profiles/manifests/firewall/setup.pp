# Clears rules and sets up pre and post classes
class profiles::firewall::setup {
    resources { 'firewall':
        purge => true
    }

    Firewall {
        before  => Class['profiles::firewall::post'],
        require => Class['profiles::firewall::pre'],
    }

    class { ['profiles::firewall::pre', 'profiles::firewall::post']: }

    class { 'firewall': }
}
