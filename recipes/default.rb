include_recipe 'squid'
include_recipe 'squid_extend::auth'

node.set[:squid][:directories] = [
  node[:squid][:log_dir],
  node[:squid][:cache_dir],
  node[:squid][:coredump_dir]
]

node.set[:squid][:log_files] = [
  node[:squid][:access_log_path],
  node[:squid][:cache_log_path]
]

node[:squid][:directories].each do |dir|
  # Create directories if they do not exist
  directory dir do
    action :create
    recursive true
    owner node[:squid][:user]
    group node[:squid][:group]
    mode 0775
    only_if { node[:squid][:user] && node[:squid][:group] && !::File.exists?(dir) }
  end
end

execute "chown-squid-directories" do
  Chef::Log.debug("Will run: chown -R #{node[:squid][:user]}:#{node[:squid][:group]} #{node[:squid][:directories].join(" ")}")
  command "chown -R #{node[:squid][:user]}:#{node[:squid][:group]} #{node[:squid][:directories].join(" ")}"
  user "root"
  action :nothing
  only_if { node[:squid][:user] && node[:squid][:group] }
end

execute "chmod-squid-directories" do
  Chef::Log.debug("Will run: chmod -R 755 #{node[:squid][:directories].join(" ")}")
  command "chmod -R 755 #{node[:squid][:directories].join(" ")}"
  user "root"
  action :nothing
end

execute "chmod-squid-log-files" do
  Chef::Log.debug("Will run: chmod -R 777 #{node[:squid][:log_files].join(" ")}")
  command "chmod -R 777 #{node[:squid][:log_files].join(" ")}"
  user "root"
  action :nothing
end

template node[:squid][:config_file] do
  cookbook  'squid_extend'
  source    'squid.conf.erb'
    
  notifies :restart, "service[#{node[:squid][:service_name]}]", :immediately
  
  notifies :run, "execute[chown-squid-directories]", :immediately
  notifies :run, "execute[chmod-squid-directories]", :immediately
  notifies :run, "execute[chmod-squid-log-files]", :immediately
end