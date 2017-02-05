#
# Cookbook Name:: vim
# Recipe:: default
#
# Copyright 2013, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

node['vim']['packages'].each{|value|
	package value do
		action :install
	end
}

cookbook_file "/etc/vimrc" do
	owner "root"
	group "root"
	mode "0644"
	source "vimrc"
end
