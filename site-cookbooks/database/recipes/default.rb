#
# Cookbook Name:: database
# Recipe:: default
#
# Copyright 2015, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

password = Chef::EncryptedDataBagItem.load("mysql", "password");

package 'mysql-server-5.5' do
	action :install
end

# mysql_service 'mysql' do
# 	port '3306'
# 	version '5.5'
# 	initial_root_password password['root']
# 	action [:create, :start]
# end

directory "/home/karuru/mysqlbackup" do
	owner 'root'
	group 'root'
	mode 0600
end

template "/etc/cron.d/mysqlbackup" do
	owner 'root'
	group 'root'
	mode 0644
	source 'mysqlbackup.cron.erb'
	variables({
		:db_pass => password['root']
	})
end

template "/usr/local/bin/mysqlbackup" do
	owner 'root'
	group 'root'
	mode 0700
	source 'mysqlbackup.sh.erb'
	variables({
		:db_pass => password['root']
	})
end
