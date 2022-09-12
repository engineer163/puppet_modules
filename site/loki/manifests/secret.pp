#module for add secret file to node
class loki::secret {
  $tmpl_filename = 'loki_gcs_credentials.json.tmpl'
  $tmpl_path     = "/etc/${tmpl_filename}"

  file {$tmpl_path:
    ensure => file,
    owner  => 'root',
    group  => 'root',
    mode   => '0644',
    source => "puppet:///modules/loki/${tmpl_filename}",
  } ~> Service['vault-agent']

  cx_vault_agent::template { 'loki_gcs_credentials.json':
    source => $tmpl_path,
    target => '/etc/loki_gcs_credentials.json',
  }

  file {'/home/loki/.config/gcloud/application_default_credentials.json':
    ensure => 'link',
    target => '/etc/loki_gcs_credentials.json',
  } ~> Service['loki']
}
