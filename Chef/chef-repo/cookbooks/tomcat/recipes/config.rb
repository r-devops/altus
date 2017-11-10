execute 'Remove webapps files' do 
  command "rm -rf webapps/*"
  cwd "/opt/#{node['tomcat']['TAR_DIR']}"
end

remote_file "/opt/#{node['tomcat']['TAR_DIR']}/webapps/student.war" do
  source "#{node['tomcat']['STUDENT_WAR']}"
  action :create
end

remote_file "/opt/#{node['tomcat']['TAR_DIR']}/lib/mysql-connector-java-5.1.40.jar" do
  source "#{node['tomcat']['MYSQL_LIB']}"
  action :create
end

template "/opt/#{node['tomcat']['TAR_DIR']}/conf/context.xml" do
  source 'context.xml.erb'
  action :create
end
