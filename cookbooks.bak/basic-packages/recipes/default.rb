#
# Cookbook Name:: basic-packages
# Recipe:: default
#
# Copyright 2013, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

node['basic-packages']['packages'].each{|value|
	package value[:name] do
		action :install
	end
}


