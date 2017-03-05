template node['kubernetes']['controller_manager']['systemdfile'] do
    source "kubernetes/systemd/kube-controller-manager.service"
    mode "0644"
    user node['kubernetes']['default_user']
    group node['kubernetes']['default_group']
end

template "#{node['kubernetes']['config_dir']}/controller-manager" do
    source "kubernetes/systemd/environ/controller-manager.erb"
    user node['kubernetes']['default_user']
    group node['kubernetes']['default_group']
    mode "0644"
    variables ({
        :cloud_provider => node['kubernetes']['cloud_provider'],
        :service_account_key => node["kubernetes"]['service_account_key']['file']
    })
end

service node['kubernetes']['controller_manager']['service_name'] do
    action [:enable, :start]
    provider Chef::Provider::Service::Systemd
end
