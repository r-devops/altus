default['tomcat']['URL']='http://www-us.apache.org/dist/tomcat/tomcat-9/v9.0.1/bin/apache-tomcat-9.0.1.tar.gz'
default['tomcat']['TAR_FILE']="#{node['tomcat']['URL']}".split('/').last
default['tomcat']['TAR_DIR']="#{node['tomcat']['TAR_FILE']}".sub('.tar.gz','')

default['tomcat']['STUDENT_WAR']='https://github.com/carreerit/cogito/raw/master/appstack/student.war'
default['tomcat']['MYSQL_LIB']='https://github.com/carreerit/cogito/raw/master/appstack/mysql-connector-java-5.1.40.jar'

default['tomcat']['dbuser']='student'
default['tomcat']['dbpass']='student@1'
default['tomcat']['dbip']='localhost'