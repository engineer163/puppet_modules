#module for add read target on write node
class loki::read {
  # Read node
  file { '/etc/loki/loki-read.yaml':
    ensure  => file,
    content => template('loki/loki-read.yaml.erb'),
    owner   => 'loki',
    group   => 'loki',
    mode    => '0644',
  }
  file { '/etc/systemd/system/loki-read.service':
    ensure => file,
    source => 'puppet:///modules/loki/loki-read.service',
    owner  => 'loki',
    group  => 'loki',
    mode   => '0644',
  }
  service {'loki-read':
    ensure    => 'running',
    enable    => true,
    subscribe => File['/etc/systemd/system/loki-read.service'],
  }
}
