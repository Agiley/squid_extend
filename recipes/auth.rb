%w{ apache2-utils }.each do |a_package|
  package a_package
end

bash "Create auth file" do
  code <<-EOH
    touch #{node[:squid][:auth][:file]}
    chown #{node[:squid][:user]} #{node[:squid][:auth][:file]}
  EOH
  
  not_if { ::File.exists?(node[:squid][:auth][:file]) }
end

htpasswd node[:squid][:auth][:file] do
  user      node[:squid][:auth][:user]
  password  node[:squid][:auth][:password]
  type      "md5"
end