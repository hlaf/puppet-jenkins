# Class jenkins::cli_helper
#
# A helper script for creating resources via the Jenkins cli
#
# Parameters:
#
# ssh_keyfile = undef
#   Defaults to the value of $::jenkins::cli_ssh_keyfile. This parameter is
#   deprecated, please set $::jenkins::cli_ssh_keyfile instead of setting this
#   directly
#
class jenkins::cli_helper (
  $ssh_keyfile             = $::jenkins::cli_ssh_keyfile,
  $port                    = undef,
  $protocol                = 'http',
  $https_keystore          = undef,
  $https_keystore_password = undef,
) {
  include ::jenkins
  include ::jenkins::cli

  if $ssh_keyfile { validate_absolute_path($ssh_keyfile) }

  Class['jenkins::cli'] ->
    Class['jenkins::cli_helper'] ->
      Anchor['jenkins::end']

  $libdir = $::jenkins::libdir
  $cli_jar = $::jenkins::cli::jar
  $port_ = $port ? { undef => jenkins_port(), default => $port }
  $prefix = jenkins_prefix()
  $helper_groovy = "${libdir}/puppet_helper.groovy"

  file { $helper_groovy:
    source  => 'puppet:///modules/jenkins/puppet_helper.groovy',
    owner   => $::jenkins::user,
    group   => $::jenkins::group,
    mode    => '0444',
    require => Class['jenkins::cli'],
  }

  if $ssh_keyfile != $::jenkins::cli_ssh_keyfile {
    info("Using jenkins::cli_helper(${ssh_keyfile}) is deprecated and will be removed in the next major version of this module")
  }

  $url = $::jenkins::cli::config::url ? {
    undef   => "${protocol}://127.0.0.1:${port_}${prefix}",
    default => $::jenkins::cli::config::url,
  }

  if $https_keystore {
    $https_keystore_arg = "-Djavax.net.ssl.trustStore=${https_keystore}"
    if $https_keystore_password {
      $https_keystore_pass_arg = "-Djavax.net.ssl.trustStorePassword=${$https_keystore_password}"
    }
  }

  $helper_cmd = join(
    delete_undef_values([
      '/bin/cat',
      $helper_groovy,
      '|',
      '/usr/bin/java',
      $https_keystore_arg,
      $https_keystore_pass_arg,
      "-jar ${::jenkins::cli::jar}",
      "-s ${url}",
      $::jenkins::_cli_auth_arg,
      'groovy ='
    ]),
    ' '
  )
}
