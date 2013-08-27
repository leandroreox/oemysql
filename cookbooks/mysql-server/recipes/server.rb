#
# Cookbook Name:: mysql
# Recipe:: server
#
# Copyright 2013 OpenEnglish
#
#

include_recipe "mysql-server::default"

if platform_family?("debian")

	# Using Data Bags
	serverbag = data_bag_item("mysqlbag", "mysql_server")

	# Using Ruby Variables 
	cache = { :dir => "/var/cache/local/preseeding"}
 
        # Using Ruby arrays 
        [serverbag['data_dir'], cache[:dir]].each do |dir|
                directory dir do
                        owner "mysql"
                        group "mysql"
                        mode "0750"
                        recursive true
                end
        end

	#coping secret key file to be used for root passwd
	cookbook_file "my_secret_key" do
        	path "/tmp/my_secret_key"
        	mode "0644"
        	action :create
	end

	serverbag = Chef::DataBagItem.load("mysqlbag", "mysql_server")
	mysql_secret = Chef::EncryptedDataBagItem.load_secret("#{serverbag['secret_path']}")
	mysql_creds = Chef::EncryptedDataBagItem.load("passwords", "mysql", mysql_secret)

	template "/var/cache/local/preseeding/mysql-server.seed" do
		source "mysql-server.seed.erb"
		owner "root"
		group "root"
		mode "0600"
		variables ({:mysql_root_pass => mysql_creds['root_pass']})
		notifies :run, "execute[preseed mysql-server]", :immediately
	end


        execute "preseed mysql-server" do
                command "debconf-set-selections /var/cache/local/preseeding/mysql-server.seed"
                action :nothing
        end

 	package serverbag['package_file'] do
                action :install
                notifies :start, "service[mysql]", :delayed
        end


	execute "reload apparmor" do
		command "invoke-rc.d apparmor reload"
		action :nothing
	end
			
	execute "mysql_install_db" do 
		command "mysql_install_db"
		action :nothing
	end

        template "/etc/apparmor.d/usr.sbin.mysqld" do
                source "usr.sbin.mysqld.erb"
                owner "root"
                group "root"
                mode "0600"
		backup 1
		action :create
		notifies :run, "execute[reload apparmor]", :immediately
		notifies :run, "execute[mysql_install_db]", :immediately
        end

        template "#{serverbag['conf_dir']}/my.cnf" do
                source "my.cnf.erb"
		# Lets use variables
		variables :wait_timeout => "60"
                owner "mysql"
                group "mysql"
                mode "0600"
        	notifies :restart, "service[mysql]", :immediately
	end
	
	service "mysql" do
    		action [:start, :enable]
	end
end

