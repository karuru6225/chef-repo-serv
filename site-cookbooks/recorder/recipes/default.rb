#
# Cookbook Name:: recorder
# Recipe:: default
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

%w(pcscd libpcsclite1 libpcsclite-dev libccid pcsc-tools git build-essential autoconf unzip pkg-config).each{|name|
	package name do
		action :install
	end
}

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
		
		wget https://www.dropbox.com/s/qq1vpzbo8cdujrb/pt3-driver.zip
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
		
		wget https://www.dropbox.com/s/0c95cgy9y8020ex/pt1-c44e16dbb0e2-arib25.tar.gz
		tar xzf pt1-c44e16dbb0e2-arib25.tar.gz
		rm -rf pt1-c44e16dbb0e2-arib25.tar.gz
		
		cd /tmp/chef-recorder/pt1-c44e16dbb0e2-arib25/
		make && make install
		
		rm -rf /tmp/chef-recorder
		mkdir /tmp/chef-recorder
		cd /tmp/chef-recorder

		wget https://www.dropbox.com/s/z2otaydwd0kgx7m/pt1-c9b1d21c5035.tar.gz
		tar xzf pt1-c9b1d21c5035.tar.gz
		rm -rf pt1-c9b1d21c5035.tar.gz
		
		cd /tmp/chef-recorder/pt1-c9b1d21c5035/recpt1/
		./autogen.sh && ./configure --enable-b25 && make && make install
	EOC
	not_if "recpt1 -v"
end

execute 'epgdump' do
	command <<-EOC
		rm -rf /tmp/chef-recorder
		mkdir /tmp/chef-recorder
		cd /tmp/chef-recorder

		wget https://www.dropbox.com/s/q2upk31ib4nvh42/epgdump.tar.gz
		tar xzf epgdump.tar.gz
		rm -rf epgdump.tar.gz
		
		cd /tmp/chef-recorder/epgdump/
		make && make install
	EOC
	not_if "epgdump"
end

=begin
execute 'epgrec' do
	command <<-EOC
		rm -rf /tmp/chef-recorder
		mkdir /tmp/chef-recorder
		cd /tmp/chef-recorder

		wget https://www.dropbox.com/s/n9o8gwavy7z60yz/epgrec_UNA_140427.tar.gz
		tar xzf epgrec_UNA_140427.tar.gz
		rm -rf epgrec_UNA_140427.tar.gz
	EOC
end
=end
