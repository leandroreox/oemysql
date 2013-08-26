#
# Cookbook Name:: testcook
# Recipe:: default
#
# Copyright 2013, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

file "/opt/testls" do
	owner "root"
	group "root"
	mode "0755"
	content "maxi la concha de tu madre <%= @node[:lean1] %> and platform <%= @node[:platform] %>"
	action :create
end

cookbook_file "testls" do
	path "/tmp/testls"
	action :create
end


template "/tmp/chupala" do
	source "maxi.erb"
	mode "0755"
	owner "root"
	group "root"
	
end

node.normal["lean1"] = "SNOWIEEEEEEEE SE VA PARA CORDOBA.INTEL.GATO"
node.set["maxi1"] = "lagarto"

template "#{node['dir']}/culo" do
	source "maxi.erb"
        mode "0755"
        owner "root"
        group "root"

end

cormenbag = data_bag_item("testbag", "maxi")


directory cormenbag["home"] do
	owner "root"
	mode "0755"
	group "root"
	action :create
end
