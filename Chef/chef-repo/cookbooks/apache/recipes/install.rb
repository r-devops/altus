%w(httpd httpd-devel gcc).each do |pack|

	package "#{pack}" do 
		action :install
	end
end


