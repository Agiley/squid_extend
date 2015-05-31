include_recipe 'squid'

include_recipe 'squid_extend::auth'

template node['squid']['config_file'] do
  cookbook "squid_extend"
  source 'squid.conf.erb'
  notifies :restart, "service[#{node['squid']['service_name']}]"
end