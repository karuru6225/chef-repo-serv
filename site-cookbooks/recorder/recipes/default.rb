#
# Cookbook Name:: recorder
# Recipe:: default
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

include_recipe 'nginx::default'
include_recipe 'php::default'
include_recipe 'database::default'


%w(pcscd libpcsclite1 libpcsclite-dev libccid pcsc-tools git build-essential autoconf unzip pkg-config ntpdate ffmpeg).each{|name|
	package name do
		action :install
	end
}

cookbook_file "/etc/cron.d/ntpdate" do
	owner 'root'
	group 'root'
	mode 0644
	source "ntpdate"
end

package 'linux-headers-' + node[:os_version] do
	action :install
end

service "pcscd" do
	action :enable
end

execute 'edit pcsc conf vendor' do
	command <<-EOC
		cp /etc/libccid_Info.plist /tmp/libccid_Info.plist
		awk 'BEGIN{ln=-3}{ print $0 }/ifdVendorID/{ ln=NR+1 }(NR == ln){ print "<string>0x04e6</string>"}' /tmp/libccid_Info.plist > /etc/libccid_Info.plist
	EOC
	not_if "grep 0x04e6 /etc/libccid_Info.plist"
	notifies :restart, "service[pcscd]", :delayed
end

execute 'edit pcsc conf product' do
	command <<-EOC
		cp /etc/libccid_Info.plist /tmp/libccid_Info.plist
		awk 'BEGIN{ln=-3}{ print $0 }/ifdProductID/{ ln=NR+1 }(NR == ln){ print "<string>0x511a</string>"}' /tmp/libccid_Info.plist > /etc/libccid_Info.plist
	EOC
	not_if "grep 0x511a /etc/libccid_Info.plist"
	notifies :restart, "service[pcscd]", :delayed
end

execute 'edit pcsc conf friendlyName' do
	command <<-EOC
		cp /etc/libccid_Info.plist /tmp/libccid_Info.plist
		awk 'BEGIN{ln=-3}{ print $0 }/ifdFriendlyName/{ ln=NR+1 }(NR == ln){ print "<string>SCR3310-NTTCom USB SmartCard Reader</string>"}' /tmp/libccid_Info.plist > /etc/libccid_Info.plist
	EOC
	not_if "grep SCR3310-NTTCom /etc/libccid_Info.plist"
	notifies :restart, "service[pcscd]", :delayed
end

file "/etc/modprobe.d/pt3-blacklist.conf" do
	owner 'root'
	group 'root'
	mode 0644
	content "blacklist earth-pt1"
	action :create
end

execute 'pt3-driver' do
	command <<-EOC
		rm -rf /tmp/chef-recorder
		mkdir /tmp/chef-recorder
		cd /tmp/chef-recorder
		
		wget https://www.dropbox.com/s/79kb8qgk7csq66u/pt3-driver.zip
		unzip pt3-driver.zip
		rm -rf pt3-driver.zip
		
		cd /tmp/chef-recorder/pt3-master/
		make && make install
	EOC
	not_if "lsmod | grep pt3"
end

execute 'pt1-recpt1' do
	command <<-EOC
		rm -rf /tmp/chef-recorder
		mkdir /tmp/chef-recorder
		cd /tmp/chef-recorder
		
		wget https://www.dropbox.com/s/el2x9qkdi0wbimi/pt1-c44e16dbb0e2-arib25.tar.gz
		tar xzf pt1-c44e16dbb0e2-arib25.tar.gz
		rm -rf pt1-c44e16dbb0e2-arib25.tar.gz
		
		cd /tmp/chef-recorder/pt1-c44e16dbb0e2-arib25/
		make && make install
		
		rm -rf /tmp/chef-recorder
		mkdir /tmp/chef-recorder
		cd /tmp/chef-recorder

		wget https://www.dropbox.com/s/jr3igz6vh1c8edw/pt1-c9b1d21c5035.tar.gz
		tar xzf pt1-c9b1d21c5035.tar.gz
		rm -rf pt1-c9b1d21c5035.tar.gz
		
		cd /tmp/chef-recorder/pt1-c9b1d21c5035/recpt1/
		./autogen.sh && ./configure --enable-b25 && make && make install
	EOC
	not_if { File.exists?("/usr/local/bin/recpt1") }
end

execute 'epgdump' do
	command <<-EOC
		rm -rf /tmp/chef-recorder
		mkdir /tmp/chef-recorder
		cd /tmp/chef-recorder

		wget https://www.dropbox.com/s/6jt2743vg3atc5t/epgdump.tar.gz
		tar xzf epgdump.tar.gz
		rm -rf epgdump.tar.gz
		
		cd /tmp/chef-recorder/epgdump/
		make && make install
	EOC
	not_if { File.exists?("/usr/local/bin/epgdump") }
end

execute 'edit at.deny' do
	command "sed -i 's/www-data//g' /etc/at.deny"
	only_if 'grep www-data /etc/at.deny'
end


execute 'epgrec' do
	command <<-EOC
		mkdir -p /var/www/epgrec

		cd /tmp
		wget https://www.dropbox.com/s/aacd1silyfr37ea/epgrec_karuru_151004.tar.bz
		tar xjf epgrec_karuru_151004.tar.bz -C /var/www/epgrec
		rm -f epgrec_karuru_151004.tar.bz
		chown -R www-data:www-data /var/www/epgrec

		cd /var/www/epgrec
		chmod 777 cache templates_c settings
	EOC
	not_if "test -d /var/www/epgrec"
end

cookbook_file '/var/www/epgrec/config.php' do
	source 'config.php'
	owner 'www-data'
	group 'www-data'
	mode '0755'	
end

password = Chef::EncryptedDataBagItem.load("mysql", "password");

execute 'create database' do
	command "mysql -u root -p" + password['root'] + " -e 'create database epgrec'"
	not_if "mysql -u root -p" + password['root'] + " -e 'show databases' | grep epgrec"
end

execute 'create user' do
	command "mysql -u root -p" + password['root'] + " -D mysql -e \"grant all on epgrec.* to epgrec@localhost identified by '" + password['epgrec']  + "'\""
	not_if "mysql -u root -p" + password['root'] + " -D mysql -e 'select User from user' | grep epgrec"
	notifies :restart, "mysql_service[default]", :delayed
end

settings = Chef::EncryptedDataBagItem.load("recorder", "settings");
template '/var/www/epgrec/settings/config.xml' do
	source 'config.xml.erb'
	owner 'www-data'
	group 'www-data'
	mode '0644'
	variables({
		:install_url => settings['install_url'],
		:bs_tuners => settings['bs_tuners'],
		:gr_tuners => settings['gr_tuners'],
		:db_host => settings['db_host'],
		:db_name => settings['db_name'],
		:db_user => settings['db_user'],
		:db_pass => password['epgrec']
	})
end

cookbook_file '/etc/cron.d/shepherd' do
	source 'shepherd'
	owner 'root'
	group 'root'
	mode '0644'
end

