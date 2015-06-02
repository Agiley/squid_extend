normal[:squid][:user]                             =   'proxy'
normal[:squid][:group]                            =   'proxy'
normal[:squid][:pid_file]                         =   '/var/run/squid3.pid'

normal[:squid][:port]                             =   8800

normal[:squid][:access_log_path]                  =   "#{node[:squid][:log_dir]}/access.log"
normal[:squid][:cache_log_path]                   =   "#{node[:squid][:log_dir]}/cache.log"
normal[:squid][:log_module]                       =   "daemon"
normal[:squid][:log_format]                       =   "squid"

normal[:squid][:dns][:nameservers]                =   ['8.8.8.8', '8.8.4.4']
normal[:squid][:dns][:ipcache_size]               =   10240
normal[:squid][:dns][:negative_dns_ttl]           =   '5 minutes'
normal[:squid][:dns][:dns_v4_first]               =   'off'

normal[:squid][:ip_addresses]                     =   [node[:ipaddress]]

normal[:squid][:auth][:enable]                    =   true
normal[:squid][:auth][:program]                   =   '/usr/lib/squid3/basic_ncsa_auth'
normal[:squid][:auth][:file]                      =   '/etc/squid3/passwords'
normal[:squid][:auth][:realm]                     =   'Squid proxy-caching web server'
normal[:squid][:auth][:children]                  =   5
normal[:squid][:auth][:credentials_ttl]           =   '1 minute'

normal[:squid][:mode]                             =   'proxy'

# Optimizations
# Automatically set the cache_mem based on the total amount of memory of the machine. E.g., 1024mb memory will be converted to 128mb cache_mem
normal[:squid][:cache_mem]                        =   "#{((node[:memory][:total].to_f * 0.125) / 1024.0).floor} MB"
normal[:squid][:cache_size]                       =   '5120' # 5gb storage
normal[:squid][:cache_replacement_policy]         =   'heap GDSF' # The heap GDSF policy optimises object hit rate by keeping smaller popular objects in cache
normal[:squid][:cache_swap_low]                   =   '87' # Start purging stuff from cache when disk usage reaches 87%
normal[:squid][:cache_swap_high]                  =   '90' # Aggressive purge of old cache at 90%

normal[:squid][:maximum_object_size]              =   '4 MB'
normal[:squid][:maximum_object_size_in_memory]    =   '256 KB' # Default is 512kb

normal[:squid][:memory_pools]                     =   'off'
normal[:squid][:half_closed_clients]              =   'off'
normal[:squid][:client_db]                        =   'off'
normal[:squid][:offline_mode]                     =   'off'