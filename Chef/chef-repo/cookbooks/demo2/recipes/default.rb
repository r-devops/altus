#
# Cookbook:: demo2
# Recipe:: default
#
# Copyright:: 2017, The Authors, All Rights Reserved.

demo2 = {
	'NAME' => 'DEMO2 from Recipe'
}
puts demo2['NAME']
log "#{node['demo2']['NAME']}" do 
  level :fatal
end

log "#{node['cpu']['0']['vendor_id']}" do 
   level :fatal

end

file '/tmp/test' do
  content '<html>This is a placeholder for the home page.</html>'
end
