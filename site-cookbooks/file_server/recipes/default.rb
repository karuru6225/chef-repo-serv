#
# Cookbook Name:: file_server
# Recipe:: default
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

case node['platform_family']
when "debian"
	%w(nfs-kernel-server samba iscsitarget iscsitarget-dkms smartmontools hdparm cpufrequtils cpufreqd).each{|name|
		package name do
			action :install
		end
	}
	
	service "cpufreqd" do
		action [:enable]
	end

	service "nfs-kernel-server" do
		action [:enable]
	end

	service "samba" do
		action [:enable]
	end

	service "iscsitarget" do
		action [:enable]
	end

	cookbook_file "/etc/default/iscsitarget" do
		owner "root"
		group "root"
		mode "0644"
		source "iscsitarget"
		notifies :restart, "service[iscsitarget]", :delayed
	end

	settings = Chef::EncryptedDataBagItem.load("file_server", "settings");
	template '/etc/iet/ietd.conf' do
		source 'ietd.conf.erb'
		owner "root"
		group "root"
		mode "0600"
		variables({
			:iscsi_iqn => settings['iscsi_iqn'],
			:iscsi_device => settings['iscsi_device'],
			:iscsi_user => settings['iscsi_user'],
			:iscsi_password => settings['iscsi_password']
		})
		notifies :restart, "service[iscsitarget]", :delayed
	end

	cookbook_file "/etc/samba/smb.conf" do
		owner "root"
		group "root"
		mode "0644"
		source "smb.conf"
		notifies :restart, "service[samba]", :delayed
	end

	cookbook_file "/etc/cron.daily/del_dsstore.sh" do
		owner "root"
		group "root"
		mode "0755"
		source "del_dsstore.sh"
	end

	cookbook_file "/etc/network/interfaces" do
		owner "root"
		group "root"
		mode "0644"
		source "interfaces"
	end
end
