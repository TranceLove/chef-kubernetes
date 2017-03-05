update_apt_cache

package ["golang", "systemd"] do
    action :install
end

create_kube_user

execute "Enable IPv4 forwarding" do
    command "sysctl net.ipv4.ip_forward=1"
end

execute "Enforce disable IPv6 and forward IPv6 traffic to IPv4" do
    command "sysctl net.ipv6.bindv6only=0 && sysctl net.ipv6.conf.all.forwarding=1"
end
