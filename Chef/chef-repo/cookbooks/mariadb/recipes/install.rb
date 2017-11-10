%w(mariadb mariadb-server).each do |pack|
  package "#{pack}" do 
    action :install
  end
end