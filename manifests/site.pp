# common useful packages
package {[
        'vim',
        'sudo',
        'screen'
    ]:
    ensure => present,
}
# show off that stdlib is installed
$module_path = get_module_path('stdlib')
notify{"stdlib path: '${module_path}'": }
