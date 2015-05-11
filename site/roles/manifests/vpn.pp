# OpenVPN server role
class roles::vpn {
    include profiles::common
    include profiles::vpn::server
}
