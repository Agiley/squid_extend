include_recipe 'squid'
include_recipe 'squid_extend::auth'

template node[:squid][:config_file] do
  cookbook  'squid_extend'
  source    'squid.conf.erb'
  notifies :restart, "service[#{node[:squid][:service_name]}]"
end

directories = [
  node[:squid][:log_dir],
  node[:squid][:cache_dir],
  node[:squid][:coredump_dir]
]

directories.each do |dir|
  
  # Create directories if they do not exist
  directory dir do
    action :create
    recursive true
    owner node[:squid][:user]
    mode 00755
    not_if { ::File.exists?(dir) }
  end
  
  # Chown existing directories to the squid / cache_effective_user
  bash "chown directory #{dir} to user #{node[:squid][:user]}" do
    code <<-EOH
      chown -R #{node[:squid][:user]}:#{node[:squid][:user]} #{dir}
      chmod -R 755 #{dir}
    EOH
    
    only_if { ::File.exists?(dir) }
  end
  
end if node[:squid][:user]

execute "sudo service #{node[:squid][:service_name]} restart"