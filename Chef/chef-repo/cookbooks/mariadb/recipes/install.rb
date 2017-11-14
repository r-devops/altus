%w(mariadb mariadb-server).each do |pack|
  package "#{pack}" do 
    action :install
  end
end

service 'mariadb' do 
	action [:start, :enable]
end

template '/tmp/student.sql' do
  source 'student.sql.erb'
  action :create
end

execute 'load db script' do 
  command 'mysql </tmp/student.sql'
end