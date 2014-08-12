#
# Cookbook Name:: github
# Recipe:: default
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

directory "/root/.ssh" do
	owner "root"
	group "root"
	mode '0700'
	action :create
end

settings = Chef::EncryptedDataBagItem.load("github", "settings");
template '/root/.ssh/config' do
	source 'config.erb'
	owner 'root'
	group 'root'
	mode '0600'
	variables({
		:filename => settings['filename']
	})
end

execute 'download key' do
	command 'wget '+settings['key_url']+' -O /root/.ssh/'+settings['filename']
end

file "/root/.ssh/"+settings['filename'] do
	owner "root"
	group "root"
	mode "0600"
	action :create
end
