template node['kubernetes']['proxy']['systemdfile'] do
    source "kubernetes/systemd/kube-proxy.service"
    mode "0644"
    user node['kubernetes']['default_user']
    group node['kubernetes']['default_group']
end

template "#{node['kubernetes']['config_dir']}/proxy" do
    source "kubernetes/systemd/environ/proxy.erb"
    user node['kubernetes']['default_user']
    group node['kubernetes']['default_group']
    mode "0644"
end

service node['kubernetes']['proxy']['service_name'] do
    action [:enable, :start]
    provider Chef::Provider::Service::Systemd
end
