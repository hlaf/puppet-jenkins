#
# jenkins::repo handles pulling in the platform specific repo classes
#
class jenkins::repo {
  include stdlib
  anchor { 'jenkins::repo::begin': }
  anchor { 'jenkins::repo::end': }

  if versioncmp(pick($::jenkins::version), '2.235.3') < 1 {
    $base_url         = 'http://pkg.jenkins-ci.org'
    $gpg_key_filename = 'jenkins-ci.org.key'
  } else {
    $base_url         = 'https://pkg.jenkins.io'
    $gpg_key_filename = 'jenkins.io.key'
  }

  if $caller_module_name != $module_name {
    fail("Use of private class ${name} by ${caller_module_name}")
  }

  if ( $::jenkins::repo ) {
    case $::osfamily {

      'RedHat', 'Linux': {
        class { 'jenkins::repo::el': }
        Anchor['jenkins::repo::begin'] ->
          Class['jenkins::repo::el'] ->
          Anchor['jenkins::repo::end']
      }

      'Debian': {
        class { 'jenkins::repo::debian': }
        Anchor['jenkins::repo::begin'] ->
          Class['jenkins::repo::debian'] ->
          Anchor['jenkins::repo::end']
      }

      'Suse' : {
        class { 'jenkins::repo::suse': }
        Anchor['jenkins::repo::begin'] ->
          Class['jenkins::repo::suse'] ->
          Anchor['jenkins::repo::end']
      }

      default: {
        fail( "Unsupported OS family: ${::osfamily}" )
      }
    }
  }
}
