#
# Cookbook Name:: ssh
# Recipe:: default
#
# Copyright 2013, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

package "openssh-server" do
	action :install
end



service "openssh" do
	case node['platform_family']
	when "rhel"
		service_name "sshd"
	when "debian"
		service_name "ssh"
	end
	action [:enable]
end


template '/etc/ssh/sshd_config' do
	owner 'root'
	group 'root'
	mode '0644'
	source 'sshd_config.erb'
	variables({:settings => node['openssh']['server']})
	action [:create]
	notifies :restart, "service[openssh]", :delayed
end