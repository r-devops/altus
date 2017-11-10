remote_file "#{node['apache']['MODJK_TAR']}" do
  source "#{node['apache']['MODJK_URL']}"
  action :create
end

execute 'Extract mod_jk tar file' do
  command "tar xf #{node['apache']['MODJK_TAR']}"
  cwd '/opt'
  not_if { File.exists?("#{node['apache']['MODJK_DIR']}") }
end

execute 'Compile Mod_jk' do 
	command './configure --with-apxs=/usr/bin/apxs && make clean && make && make install'
	cwd "#{node['apache']['MODJK_DIR']}/native"
	not_if { File.exists?("/etc/httpd/modules/mod_jk.so") }
end

cookbook_file '/etc/httpd/conf.d/mod_jk.conf' do
  source 'mod_jk.conf'
  action :create
end

template '/etc/httpd/conf.d/workers.properties' do
  source 'workers.properties.erb'
  action :create
end