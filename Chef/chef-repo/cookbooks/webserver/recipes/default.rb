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

remote_file '/opt/tomcat-connectors-1.2.42-src.tar.gz' do
  source 'http://redrockdigimark.com/apachemirror/tomcat/tomcat-connectors/jk/tomcat-connectors-1.2.42-src.tar.gz'
  action :create
end

execute 'Extract mod_jk tar file' do
  command 'tar xf tomcat-connectors-1.2.42-src.tar.gz'
  cwd '/opt'
  not_if { File.exists?("/opt/tomcat-connectors-1.2.42-src") }
end

execute 'Compile Mod_jk' do 
	command './configure --with-apxs=/usr/bin/apxs && make clean && make && make install'
	cwd '/opt/tomcat-connectors-1.2.42-src/native'
	not_if { File.exists?("/etc/httpd/modules/mod_jk.so") }
end

service "httpd" do
  action [:restart, :enable]
end






