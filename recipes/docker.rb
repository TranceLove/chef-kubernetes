package ["wget", "bridge-utils"] do
    action :upgrade
end

execute "Install Docker" do
    command "wget -q -O- https://get.docker.com | bash"
    not_if { ::File.exists?("/usr/bin/docker") }
end

service "docker" do
    action :restart
end

group "docker" do
    members node['kubernetes']['default_user']
    action :modify
    append true
end
