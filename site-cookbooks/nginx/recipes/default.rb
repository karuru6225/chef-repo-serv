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

cookbook_file '/etc/nginx/sites-enabled/000-main.conf' do
	source '000-main.conf'
	owner 'root'
	group 'root'
	mode '0644'
	notifies :restart, 'service[nginx]', :delayed
end

execute 'install h5ai' do
	command <<-EOC
		rm -rf /tmp/chef-nginx
		mkdir /tmp/chef-nginx
		cd /tmp/chef-nginx

		wget https://www.dropbox.com/s/we299qs6eoi7l98/h5ai-0.26.1.zip

		unzip h5ai-0.26.1.zip -d /var/www/
	EOC
end

cookbook_file '/var/www/.htpasswd' do
	source 'htpasswd'
	owner 'root'
	group 'root'
	mode '0644'
	notifies :restart, 'service[nginx]', :delayed
end

