# loki - module for managing installation of loki - like prometheus but for logs
class loki (
  $loki_version,
  $target_loki = 'write',
){
  # Creating group, user, dirs
  group { 'loki':
    name => 'loki',
  }
  user { 'loki':
    name   => 'loki',
    groups => 'loki',
    shell  => '/sbin/nologin',
  }
  file { ['/var/lib/loki','/var/lib/loki/wal','/var/lib/loki/index','/etc/loki','/home/loki','/home/loki/.config','/home/loki/.config/gcloud']:
    ensure => 'directory',
    owner  => 'loki',
    group  => 'loki',
  }
  # Install Loki package
  package { 'loki':
    ensure => $loki_version,
  }
  # Write node
  if $target_loki == 'write' {
    file { '/etc/loki/loki.yaml':
      ensure  => file,
      content => template('loki/loki.yaml.erb'),
      owner   => 'loki',
      group   => 'loki',
      mode    => '0644',
    }
    file { '/etc/systemd/system/loki.service':
      ensure => file,
      source => 'puppet:///modules/loki/loki.service',
      owner  => 'loki',
      group  => 'loki',
      mode   => '0644',
    }
    service {'loki':
      ensure    => 'running',
      enable    => true,
      subscribe => File['/etc/systemd/system/loki.service'],
    }
  }
}
