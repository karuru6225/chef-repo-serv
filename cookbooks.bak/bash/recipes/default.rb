#
# Cookbook Name:: bash
# Recipe:: default
#
# Copyright 2013, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

file "/etc/skel/.bash_history" do
	owner "root"
	group "root"
	mode "0644"
end

cookbook_file "/etc/skel/.bash_logout" do
	owner 'root'
	group 'root'
	mode '0644'
	source 'bash_logout'
end

cookbook_file "/etc/skel/.bash_profile" do
	owner 'root'
	group 'root'
	mode '0644'
	source 'bash_profile'
end

cookbook_file "/etc/skel/.bash_colors" do
	owner 'root'
	group 'root'
	mode '0644'
	source 'bash_colors'
end

cookbook_file "/etc/skel/.bashrc" do
	owner 'root'
	group 'root'
	mode '0644'
	source 'bashrc'
end
