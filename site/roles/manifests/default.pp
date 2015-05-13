# default server role
class roles::default {
    include profiles::common
    include profiles::dns::client
    include profiles::vpn::client
}
