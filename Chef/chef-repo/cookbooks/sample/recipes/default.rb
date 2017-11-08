#
# Cookbook:: sample
# Recipe:: default
#
# Copyright:: 2017, The Authors, All Rights Reserved.

log 'message' do
  message 'A message add to the log.'
  level :info
end

x =1 
puts 'Hello WOrld'
puts "X = #{x}"
