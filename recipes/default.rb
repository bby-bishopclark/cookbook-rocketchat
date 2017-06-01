#
# Cookbook Name:: RocketChat
# Recipe:: default
#
# Copyright 2016, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

package "GraphicsMagick" do
  action :install
end

package "gcc-c++" do
  action :install
end

package "make" do
  action :install
end

execute "curl -sL" do
  cwd "/home/ec2-user/"
  command "curl -sL https://rpm.nodesource.com/setup_4.x | bash -;"
  not_if  { File.exists?("/etc/yum.repos.d/nodesource-el.repo") }
end

package "nodejs" do
  action :install
end

cookbook_file "/etc/yum.repos.d/mongodb.repo" do
  source "default/mongodb.repo"
  owner "root"
  group "root"
  mode 0644
end

package "mongodb-org-server" do
  action :install
end

package "mongodb-org" do
  action :install
end

group 'rocketchat' do
  group_name 'rocketchat'
  action     [:create]
end

user 'rocketchat' do
  group    'rocketchat'
  supports :manage_home => true
  action   [:create]
end

remote_file "/usr/local/src/rocket.chat.tgz" do
  source "https://rocket.chat/releases/latest/download"
  owner "root"
  group "root"
  mode "0755"
end

execute "tar zxvf rocket.chat.tgz" do
  cwd "/usr/local/src"
  command "tar zxvf rocket.chat.tgz; mv bundle Rocket.Chat; mv Rocket.Chat /opt/; chown rocketchat:rocketchat -R /opt/Rocket.Chat;"
  not_if  { Dir.exists?("/opt/Rocket.Chat") }
end

execute "npm install" do
  cwd "/opt/Rocket.Chat/programs/server"
  command "npm install -g inherits n; npm install;"
  not_if  { Dir.exists?("/opt/Rocket.Chat/programs/server/node_modules") }
end

#cookbook_file "/opt/Rocket.Chat/rocketchat.sh" do
#  source "default/rocketchat.sh"
#  owner "root"
#  group "root"
#  mode 0755
#end

template "/opt/Rocket.Chat/rocketchat.sh" do
  owner "root"
  group "root"
  mode  0755
  source "default/rocketchat.sh.erb"
  variables({
    :rocketchat_ip => node[:rocketchat][:ip]
  })
end



link "/etc/init.d/rocketchat" do
  to "/opt/Rocket.Chat/rocketchat.sh"
end

#execute "chkconfig --add rocketchat" do
#  command "chkconfig --add rocketchat;"
#end

package "nginx" do
  action :install
end

cookbook_file "/etc/nginx/conf.d/rocketchat.conf" do
  source "default/rocketchat.conf"
  owner "root"
  group "root"
  mode 0755
end

cookbook_file "/etc/nginx/nginx.conf" do
  source "default/nginx.conf"
  owner "root"
  group "root"
  mode 0755
end

service "nginx" do
  ignore_failure true
  action [:enable, :start]
end

service "mongod" do
  ignore_failure true
  action [:enable, :start]
end

service "rocketchat" do
  ignore_failure true
  action [:enable, :start]
end
