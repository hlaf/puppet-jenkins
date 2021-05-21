# Class: jenkins::repo::el
#
class jenkins::repo::el
{

  if $caller_module_name != $module_name {
    fail("Use of private class ${name} by ${caller_module_name}")
  }

  if $jenkins::lts {
    $baseurl = "${jenkins::repo::base_url}/redhat-stable/"
  } else {
    $baseurl = "${jenkins::repo::base_url}/redhat/"
  }

  yumrepo { 'jenkins':
    descr    => 'Jenkins',
    baseurl  => $baseurl,
    gpgcheck => 1,
    gpgkey   => "${baseurl}${jenkins::repo::gpg_key_filename}",
    enabled  => 1,
    proxy    => $jenkins::repo_proxy,
  }

}
