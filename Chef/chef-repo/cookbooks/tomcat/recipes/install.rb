package 'java-1.8.0-openjdk' do 
  action :install
end

remote_file "/opt/#{node['tomcat']['TAR_FILE']}" do
  source "#{node['tomcat']['URL']}"
  action :create
end

execute 'Extract tomcat tar file' do
  command "tar xf #{node['tomcat']['TAR_FILE']}"
  cwd '/opt'
  not_if { File.exists?("/opt/#{node['tomcat']['TAR_DIR']}") }
end
