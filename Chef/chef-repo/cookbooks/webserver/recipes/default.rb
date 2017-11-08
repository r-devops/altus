#
# Cookbook:: webserver
# Recipe:: default
#
# Copyright:: 2017, The Authors, All Rights Reserved.

%w(httpd httpd-devel gcc).each do |pack|

	package "#{pack}" do 
		action :install
	end
end

service "httpd" do
  action [:start, :enable]
end
