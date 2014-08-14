#
# Cookbook Name:: ssmtp
# Recipe:: default
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

package 'ssmtp' do
	action :install
end


settings = Chef::EncryptedDataBagItem.load("ssmtp", "settings");
template '/etc/ssmtp/ssmtp.conf' do
	source 'ssmtp.conf.erb'
	owner 'root'
	group 'root'
	mode '0644'
	variables({
		:email => settings['email'],
		:smtp => settings['smtp'],
		:hostname => settings['hostname'],
		:username => settings['username'],
		:password => settings['password'],
		:usestarttls => settings['usestarttls']
	})
end


