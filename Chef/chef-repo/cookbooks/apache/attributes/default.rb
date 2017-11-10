default['apache']['MODJK_URL']='http://redrockdigimark.com/apachemirror/tomcat/tomcat-connectors/jk/tomcat-connectors-1.2.42-src.tar.gz'
SPLIT="#{node['apache']['MODJK_URL']}".split('/')
TAR=SPLIT.last
default['apache']['MODJK_TAR']="/opt/#{TAR}"
default['apache']['MODJK_DIR']="#{node['apache']['MODJK_TAR']}".sub('.tar.gz','')

default['apache']['TOMCATIP']='localhost'