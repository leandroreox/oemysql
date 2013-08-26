#
# Cookbook Name:: mysql
# Recipe:: client
#
# Copyright 2013 OpenEnglish
#
#


if platform_family?("debian")

        # Using Data Bags
        serverbag = data_bag_item("mysqlbag", "mysql_client")

        package serverbag['package_file'] do
                action :install
        end

end
	
