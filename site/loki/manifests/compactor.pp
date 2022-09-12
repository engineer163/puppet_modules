#module for add compactor target on write node
class loki::compactor {
  # Compactor node
  file { '/etc/loki/loki-compactor.yaml':
    ensure  => file,
    content => template('loki/loki-compactor.yaml.erb'),
    owner   => 'loki',
    group   => 'loki',
    mode    => '0644',
  }
  file { '/etc/systemd/system/loki-compactor.service':
    ensure => file,
    source => 'puppet:///modules/loki/loki-compactor.service',
    owner  => 'loki',
    group  => 'loki',
    mode   => '0644',
  }
  service {'loki-compactor':
    ensure    => 'running',
    enable    => true,
    subscribe => File['/etc/systemd/system/loki-compactor.service'],
  }
}
