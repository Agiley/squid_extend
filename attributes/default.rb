normal[:squid][:user]                     =   'proxy'
normal[:squid][:port]                     =   8800
normal[:squid][:pid_file]                 =   '/var/run/squid3.pid'

normal[:squid][:mode]                     =   'proxy'
normal[:squid][:enable_cache_dir]         =   false

normal[:squid][:dns][:nameservers]        =   ['8.8.8.8', '8.8.4.4']
normal[:squid][:dns][:ipcache_size]       =   10240
normal[:squid][:dns][:negative_dns_ttl]   =   '5 minutes'

normal[:squid][:auth][:enable]            =   true
normal[:squid][:auth][:program]           =   '/usr/lib/squid3/basic_ncsa_auth'
normal[:squid][:auth][:file]              =   '/etc/squid3/passwords'
normal[:squid][:auth][:realm]             =   'Squid proxy-caching web server'
normal[:squid][:auth][:children]          =   5
normal[:squid][:auth][:credentials_ttl]   =   '1 minute'