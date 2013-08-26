#
# Cookbook Name:: mysql-server
# Recipe:: default
#
# Copyright 2013, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

#Updating apt-packages 

execute "apt-get-update" do
  command "apt-get update"
  ignore_failure true
  action :run
  only_if do
    File.exists?('/var/lib/apt/periodic/update-success-stamp') &&
    File.mtime('/var/lib/apt/periodic/update-success-stamp') < Time.now - 60
  end
end

include_recipe "mysql-server::client"	
