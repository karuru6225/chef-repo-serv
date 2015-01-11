#
# Cookbook Name:: monitor
# Recipe:: default
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

%w(sysstat lm-sensors).each{|name|
	package name do
		action :install
	end
}

cookbook_file '/etc/default/sysstat' do
	owner 'root'
	group 'root'
	mode '0644'
	source 'sysstat'
end

cookbook_file '/etc/default/diskmon' do
	owner 'root'
	group 'root'
	mode '0644'
	source 'diskmon'
end

