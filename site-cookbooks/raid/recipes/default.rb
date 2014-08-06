#
# Cookbook Name:: raid
# Recipe:: default
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#


package "mdadm" do
	action :install
end

package "lvm2" do
	action :install
end
