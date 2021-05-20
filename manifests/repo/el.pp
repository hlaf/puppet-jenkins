# Class: jenkins::repo::el
#
class jenkins::repo::el
{

  if $caller_module_name != $module_name {
    fail("Use of private class ${name} by ${caller_module_name}")
  }

  $repo_proxy = $::jenkins::repo_proxy

  $jenkins_repo_base_url = 'https://pkg.jenkins.io'
  $gpg_key_filename      = 'jenkins.io.key'

  if $jenkins::lts {
    $base_url = "${jenkins_repo_base_url}/redhat-stable/"
  } else {
    $base_url = "${jenkins_repo_base_url}/redhat/"
  }

  yumrepo {'jenkins':
    descr    => 'Jenkins',
    baseurl  => $base_url,
    gpgcheck => 1,
    gpgkey   => "${base_url}${gpg_key_filename}",
    enabled  => 1,
    proxy    => $repo_proxy
  }

}
