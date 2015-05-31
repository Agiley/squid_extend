normal[:squid][:user]                     =   'proxy'
normal[:squid][:group]                    =   'proxy'
normal[:squid][:port]                     =   8800
normal[:squid][:pid_file]                 =   '/var/run/squid3.pid'

normal[:squid][:access_log_path]          =   "#{node[:squid][:log_dir]}/access.log"
normal[:squid][:cache_log_path]           =   "#{node[:squid][:log_dir]}/cache.log"
normal[:squid][:log_module]               =   "daemon"
normal[:squid][:log_format]               =   "squid"

normal[:squid][:dns][:nameservers]        =   ['8.8.8.8', '8.8.4.4']
normal[:squid][:dns][:ipcache_size]       =   10240
normal[:squid][:dns][:negative_dns_ttl]   =   '5 minutes'

normal[:squid][:ip_addresses]             =   [node[:ipaddress]]

normal[:squid][:auth][:enable]            =   true
normal[:squid][:auth][:program]           =   '/usr/lib/squid3/basic_ncsa_auth'
normal[:squid][:auth][:file]              =   '/etc/squid3/passwords'
normal[:squid][:auth][:realm]             =   'Squid proxy-caching web server'
normal[:squid][:auth][:children]          =   5
normal[:squid][:auth][:credentials_ttl]   =   '1 minute'

normal[:squid][:mode]                     =   'proxy'