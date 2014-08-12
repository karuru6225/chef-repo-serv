#
# Cookbook Name:: file_server
# Recipe:: default
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

case node['platform_family']
when "debian"
	%w(nfs-kernel-server samba smartmontools).each{|name|
		package name do
			action :install
		end
	}
	
	service "nfs-kernel-server" do
		action [:enable]
	end

	service "samba" do
		action [:enable]
	end

	cookbook_file "/etc/samba/smb.conf" do
		owner "root"
		group "root"
		mode "0644"
		source "smb.conf"
		notifies :restart, "service[samba]", :delayed
	end
end
