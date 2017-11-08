#!/bin/bash

### Variables
TOMCAT_URL="http://www-us.apache.org/dist/tomcat/tomcat-9/v9.0.0.M26/bin/apache-tomcat-9.0.0.M26.tar.gz"
TOMCAT_BASE_DIR=/opt
TOMCAT_TAR_FILE=$(echo $TOMCAT_URL | cut -d / -f 9)
TOMCAT_LOC="/opt/$(echo $TOMCAT_TAR_FILE|sed -e 's/.tar.gz//')"
TOMCAT_JDBC_CON_URL="https://github.com/carreerit/cogito/raw/master/appstack/mysql-connector-java-5.1.40.jar"
TOMCAT_JDBC_FILE=$(echo $TOMCAT_JDBC_CON_URL| cut -d / -f9)
TOMCAT_WAR_URL="https://github.com/carreerit/cogito/raw/master/appstack/student.war"

WEB_MOD_JK_URL="http://redrockdigimark.com/apachemirror/tomcat/tomcat-connectors/jk/tomcat-connectors-1.2.42-src.tar.gz"
WEB_MOD_JK_TAR="$(echo $WEB_MOD_JK_URL | cut -d / -f 8)"
WEB_MOD_JK_LOC="/opt/$(echo $WEB_MOD_JK_TAR | sed -e 's/.tar.gz//')/native"

CONNECTOR='<Resource name="jdbc/TestDB" auth="Container" type="javax.sql.DataSource" maxTotal="100" maxIdle="30" maxWaitMillis="10000"     username="student" password="student@1" driverClassName="com.mysql.jdbc.Driver" url="jdbc:mysql://localhost:3306/studentapp"/>'

### Functions
Status() {
	if [ $1 -eq 0 ]; then 
		echo -e "\e[32mSuccess\e[0m"
	else
		echo -e "\e[31mFailed\e[0m"
	fi
}

### Main Program

### Check root user or not.
USERID=$(id -u)
if [ $USERID -ne 0 ]; then
	echo "You should be root user to perform this script"
	exit 1
fi

## Install Web Server
echo -n "Installing Web Server  .. "
yum install httpd httpd-devel gcc -y &>/dev/null
Status $?

## Install Tomcat Server
echo -n "Installing Java .. "
yum install java -y &>/dev/null
Status $?
echo -n "Installing Tomcat Server .. "
cd $TOMCAT_BASE_DIR
wget $TOMCAT_URL -O $TOMCAT_TAR_FILE &>/dev/null
tar xf $TOMCAT_TAR_FILE &>/dev/null 
Status $?

## Install DB Server
echo -n "Installing DB Server .. "
yum install mariadb mariadb-server -y &>/dev/null
Status $?

echo -n -e "Starting DB .. "
systemctl enable mariadb &>/dev/null
systemctl start mariadb &>/dev/null
Status $?

echo "create database if not exists studentapp;
use studentapp;
CREATE TABLE if not exists Students(student_id INT NOT NULL AUTO_INCREMENT,
	student_name VARCHAR(100) NOT NULL,
    student_addr VARCHAR(100) NOT NULL,
	student_age VARCHAR(3) NOT NULL,
	student_qual VARCHAR(20) NOT NULL,
	student_percent VARCHAR(10) NOT NULL,
	student_year_passed VARCHAR(10) NOT NULL,
	PRIMARY KEY (student_id)
);
grant all privileges on studentapp.* to 'student'@'localhost' identified by 'student@1'; " >/tmp/student.sql

echo -n "Configuring student app DB .. "
mysql </tmp/student.sql 
Status $?

## Configuring TOmcat
echo -n 'Configuring Tomcat .. '
cd $TOMCAT_LOC
sed -i -e '/TestDB/ d' -e "$ i $CONNECTOR" conf/context.xml
rm -rf webapps/*
wget $TOMCAT_JDBC_CON_URL -O lib/$TOMCAT_JDBC_FILE &>/dev/null
wget $TOMCAT_WAR_URL -O webapps/student.war  &>/dev/null
if [ -f lib/$TOMCAT_JDBC_FILE -a -f webapps/student.war ]; then 
	Status 0
else
	Status 1
fi

### Configuring Web Server
echo -n "Configuring Apache Web Server .. "
wget $WEB_MOD_JK_URL -O /opt/$WEB_MOD_JK_TAR &>/dev/null
cd /opt
tar xf $WEB_MOD_JK_TAR 
cd $WEB_MOD_JK_LOC
./configure --with-apxs=/bin/apxs &>/dev/null
make &>/dev/null
make install &>/dev/null 
echo 'LoadModule jk_module modules/mod_jk.so
JkWorkersFile conf.d/workers.properties
JkLogFile logs/mod_jk.log
JkLogLevel info
JkLogStampFormat "[%a %b %d %H:%M:%S %Y]"
JkOptions +ForwardKeySize +ForwardURICompat -ForwardDirectories
JkRequestLogFormat "%w %V %T"
JkMount /student tomcatA
JkMount /student/* tomcatA' >/etc/httpd/conf.d/mod_jk.conf 

echo '### Define workers
worker.list=tomcatA
### Set properties
worker.tomcatA.type=ajp13
worker.tomcatA.host=localhost
worker.tomcatA.port=8009' >/etc/httpd/conf.d/workers.properties

## Restart Services
systemctl restart httpd
$TOMCAT_LOC/bin/startup.sh &>/dev/null 
Status $?

