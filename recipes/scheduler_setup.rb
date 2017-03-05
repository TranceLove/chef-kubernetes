template node['kubernetes']['scheduler']['systemdfile'] do
    source "kubernetes/systemd/kube-scheduler.service"
    mode "0644"
    user node['kubernetes']['default_user']
    group node['kubernetes']['default_group']
end

template "#{node['kubernetes']['config_dir']}/scheduler" do
    source "kubernetes/systemd/environ/scheduler.erb"
    user node['kubernetes']['default_user']
    group node['kubernetes']['default_group']
    mode "0644"
end

service node['kubernetes']['scheduler']['service_name'] do
    action [:enable, :start]
    provider Chef::Provider::Service::Systemd
end
