class zabbix::params {
  $checks = [
    'hardware.conf',
    'software.conf',
  ]

  $agent_config = '/etc/zabbix/zabbix_agentd.conf'

  $agent_packages = ['zabbix-agent']

  $agent_service = 'zabbix-agent'

  $server_config = '/etc/zabbix/zabbix_server.conf'

  $server_packages = [
    'puppet-module-puppetlabs-mysql',
    'zabbix-frontend-php',
    'zabbix-server-mysql',
  ]

  $server_service = 'zabbix-server'

  if $external_host {
    $server_fqdn = '91.218.144.129'
  } else {
    $server_fqdn = 'monitor-product.vm.mirantis.net'
  }

  # MySQL options
  $innodb_buffer_pool_size = floor($::memorysize_mb/2*1024*1024)
  $innodb_file_per_table = 1
  $max_connections = 1024
}