#
# Cookbook Name:: nginx
# Recipe:: default
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

%w(nginx).each{|name|
	package name do
		action :install
	end
}

service 'nginx' do
	action :enable
end

cookbook_file '/etc/nginx/nginx.conf' do
	source 'nginx.conf'
	owner 'root'
	group 'root'
	mode '0644'
	notifies :restart, 'service[nginx]', :delayed
end

directory '/var/www' do
	owner 'www-data'
	group 'www-data'
	action :create
end

settings = Chef::EncryptedDataBagItem.load("nginx", "settings");
template '/etc/nginx/sites-enabled/000-main.conf' do
	source '000-main.conf.erb'
	owner 'root'
	group 'root'
	mode '0644'
	variables({
		:domain => settings['domain'],
		:lan_addr => settings['lan_addr']
	})
	notifies :restart, 'service[nginx]', :delayed
end
