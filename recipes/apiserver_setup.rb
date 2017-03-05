prepare_svc_account_key

template node['kubernetes']['apiserver']['systemdfile'] do
    source "kubernetes/systemd/kube-apiserver.service"
    mode "0644"
    user "root"
    group "root"
end

template "#{node['kubernetes']['config_dir']}/apiserver" do
    source "kubernetes/systemd/environ/apiserver.erb"
    user "root"
    group "root"
    mode "0644"
    variables ({
        :etcd_master_url => node['kubernetes']['etcd']['local_master_url'] || node['kubernetes']['etcd']['master_url'],
        :bind_address => node['kubernetes']['apiserver']['bind_address'],
        :bind_port => node['kubernetes']['apiserver']['bind_port'],
        :node_port => node["kubernetes"]["kubelet"]['port'],
        :service_cluster_ip_range => node['kubernetes']['cluster']['service_cluster_ip_range'],
        :secure_bind_port => node['kubernetes']['apiserver']['secure_bind_port'],
        :service_account_key => node["kubernetes"]['service_account_key']['file']
    })
end

service node['kubernetes']['apiserver']['service_name'] do
    action [:enable, :start]
    provider Chef::Provider::Service::Systemd
end
