#
# Cookbook Name:: ups-tools
# Recipe:: default
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

execute 'install packages' do
	command <<-EOC
		cd /tmp/
		wget https://www.dropbox.com/s/aga0db18w3gfmx9/PPL_1.3.1_amd64.deb
		dpkg -i PPL_1.3.1_amd64.deb
		rm -rf PPL_1.3.1_amd64.deb
	EOC
	not_if "type pwrstat > /dev/null"
end

service 'pwrstatd' do
	action :enable
end

cookbook_file '/etc/pwrstatd.conf' do
	source 'pwrstatd.conf'
	owner 'root'
	group 'root'
	mode '0644'
	notifies :restart, 'service[pwrstatd]', :delayed
end

cookbook_file '/etc/pwrstatd-powerfail.sh' do
	source 'pwrstatd-powerfail.sh'
	owner 'root'
	group 'root'
	mode '0744'
	notifies :restart, 'service[pwrstatd]', :delayed
end

cookbook_file '/etc/pwrstatd-lowbatt.sh' do
	source 'pwrstatd-lowbatt.sh'
	owner 'root'
	group 'root'
	mode '0744'
	notifies :restart, 'service[pwrstatd]', :delayed
end
