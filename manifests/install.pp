# Private class
define haproxy::install (
  $package_ensure,
  $package_name = undef,  # A default is required for Puppet 2.7 compatibility. When 2.7 is no longer supported, this parameter default should be removed.
  $config_file,
  $binary_path,
) {
  if $caller_module_name != $module_name {
    fail("Use of private class ${name} by ${caller_module_name}")
  }

  if $package_name != undef {
    if $package_name != 'haproxy' {
      package { 'centos-release-scl':
        ensure => $package_ensure,
      }

      package { $package_name:
        ensure  => $package_ensure,
        require => Package['centos-release-scl'],
        alias   => 'haproxy',
      }

      file { '/usr/sbin/haproxy':
        ensure  => link,
        force   => true,
        target  => $binary_path,
      }

      file { '/etc/haproxy/haproxy.cfg':
        ensure  => link,
        force   => true,
        target  => $config_file,
      }
    } else {
      package { $package_name:
        ensure => $package_ensure,
        alias  => 'haproxy',
      }
    }
  }

}
