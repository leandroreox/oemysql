#
# Cookbook Name:: issue
# Recipe:: default
#
# Copyright 2013, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#


template "/etc/issue.net" do
	source "issue.erb"
	mode "0644"
end

cookbook_file "sshd_config" do
	backup 1
	path "/etc/ssh/sshd_config"
	owner "root"
	group "root"
	mode "0644"
	action :create
end

service "ssh" do
        supports :status => true, :restart => true, :stop => false, :start => true
	action :restart
end


