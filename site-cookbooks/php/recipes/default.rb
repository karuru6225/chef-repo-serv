#
# Cookbook Name:: php
# Recipe:: default
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

%w(php5-fpm php5-cli php5-mysql).each{|name|
	package name do
		action :install
	end
}

cookbook_file '/etc/php5/cli/php.ini' do
	source 'cli-php.ini'
	owner 'root'
	group 'root'
	mode '0644'
end

cookbook_file '/etc/php5/fpm/php.ini' do
	source 'fpm-php.ini'
	owner 'root'
	group 'root'
	mode '0644'
end
