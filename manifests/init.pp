# Class: odaiapiman
#
# This module manages odaiapiman
#
# Parameters: none
#
# Actions:
#
# Requires: see Modulefile
#
# Sample Usage:
#
class odaiapiman ($repo_server) {
  $bam = hiera('bam', undef)
  $greg = hiera('greg', undef)
  $am = hiera('am', undef)

  package { 'unzip': ensure => present, }

  if !defined(Package['mysql']) {
    package { 'mysql': ensure => present, }
  }

  # REQUIREMENTS
  # Java
  class { 'opendai_java':
    distribution => 'jdk',
    version      => '6u25',
    repos        => $repo_server,
  }

  class { 'wso2am':
    download_site      => "http://${repo_server}/",
    db_type            => $am["db_type"],
    db_host            => $am["db_host"],
    db_name            => $am["db_name"],
    db_user            => $am["db_user"],
    db_password        => $am["db_password"],
    db_tag             => $am["db_tag"],
    version            => $am["version"],
    admin_password     => $am["admin_password"],
    external_greg      => $am["external_greg"],
    greg_server_url    => $greg["server_url"],
    greg_db_host       => $greg["db_host"],
    greg_db_name       => $greg["db_name"],
    greg_db_type       => $greg["db_type"],
    greg_username      => $greg["db_name"],
    greg_password      => $greg["db_password"],
    external_bam       => $am["external_bam"],
    bam_server_url     => $bam["server_url"],
    bam_db_host        => $bam["db_host"],
    bam_db_port        => $bam["db_port"],
    bam_db_name        => $bam["db_name"],
    bam_db_type        => $bam["db_type"],
    bam_username       => $bam["db_name"],
    bam_db_password    => $bam["db_password"],
    bam_admin_password => $bam["admin_password"],
    bam_thrift_port    => $bam["thrift_port"],
    behind_proxy       => $am["behind_proxy"],
    proxy_port         => $am["proxy_port"],
    proxy_ssl_port     => $am["proxy_ssl_port"],
    proxy_name         => $am["proxy_name"],
    proxy_gateway_path => $am["proxy_gateway_path"],
    require            => [Class['opendai_java'], Package['unzip'], Package['mysql']]
  }

  @@wso2bam::add_analitics { "API_Manager_Analytics.tbox":
    tbox_path => "am/${am["version"]}",
    tag       => $bam["analitics_tag"],
  }

}