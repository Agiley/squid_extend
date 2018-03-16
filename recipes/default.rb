include_recipe 'squid'
include_recipe 'squid_extend::auth'

node.default[:squid][:directories] = [
  node[:squid][:log_dir],
  node[:squid][:cache_dir],
  node[:squid][:coredump_dir]
].uniq

node.default[:squid][:log_files] = [
  node[:squid][:access_log_path],
  node[:squid][:cache_log_path]
].uniq

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
  Chef::Log.debug("Will run: chown -Rf #{node[:squid][:user]}:#{node[:squid][:group]} #{node[:squid][:directories].join(" ")}")
  command "chown -Rf #{node[:squid][:user]}:#{node[:squid][:group]} #{node[:squid][:directories].join(" ")}"
  user "root"
  action :nothing
  only_if { node[:squid][:user] && node[:squid][:group] }
  ignore_failure true
end

execute "chmod-squid-directories" do
  Chef::Log.debug("Will run: chmod -Rf 755 #{node[:squid][:directories].join(" ")}")
  command "chmod -Rf 755 #{node[:squid][:directories].join(" ")}"
  user "root"
  action :nothing
  ignore_failure true
end

execute "chmod-squid-log-directory" do
  Chef::Log.debug("Will run: chmod 777 #{node[:squid][:log_dir]}")
  command "chmod 777 #{node[:squid][:log_dir]}"
  user "root"
  action :nothing
  ignore_failure true
end

template node[:squid][:config_file] do
  cookbook  'squid_extend'
  source    'squid.conf.erb'
  
  notifies :run, "execute[chown-squid-directories]", :immediately
  notifies :run, "execute[chmod-squid-directories]", :immediately
  notifies :run, "execute[chmod-squid-log-directory]", :immediately
    
  notifies :restart, "service[squid]", :immediately
end

# Re-generate logrotate file so that it uses the correct user:group for su
logrotate_app "squid" do
  cookbook "logrotate"
  path "#{node[:squid][:log_dir]}/*.log"
  enable false
end

logrotate_app "squid" do
  cookbook "logrotate"
  path "#{node[:squid][:log_dir]}/*.log"
  enable true
  su "#{node[:squid][:user]} #{node[:squid][:group]}"
  frequency "daily"
  rotate 2
  sharedscripts true
  prerotate "test ! -x #{node[:squid][:sarg][:binary]} || #{node[:squid][:sarg][:binary]}"
  postrotate "test ! -e #{node[:squid][:pid_file]} || test ! -x #{node[:squid][:binary]} || #{node[:squid][:binary]} -k rotate"
  options ["compress", "delaycompress", "missingok", "nocreate"]
end