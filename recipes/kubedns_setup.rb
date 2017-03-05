template node['kubernetes']['kubedns']['systemdfile'] do
    source "kubernetes/systemd/kube-dns.service"
    mode "0644"
    user node['kubernetes']['default_user']
    group node['kubernetes']['default_group']
end

template "#{node['kubernetes']['config_dir']}/kube-dns" do
    source "kubernetes/systemd/environ/kubedns.erb"
    user node['kubernetes']['default_user']
    group node['kubernetes']['default_group']
    mode "0644"
    variables ({
        :listen_port => node['kubernetes']['kubedns']['listen_port'],
        :cluster_domain => node['kubernetes']['cluster']['domain'],
        :master_url => node['kubernetes']['apiserver']['local_master_url'] || node['kubernetes']['apiserver']['master_url'],
        :log_dir => node['kubernetes']['kubedns']['log_dir'],
    })
end

directory node['kubernetes']['kubedns']['log_dir'] do
    user node['kubernetes']['default_user']
    group node['kubernetes']['default_group']
    recursive true
    mode "0755"
    action :create
    not_if { ::File.exists?("#{node['kubernetes']['kubedns']['log_dir']}") }
end

service node['kubernetes']['kubedns']['service_name'] do
    action [:enable, :start]
    provider Chef::Provider::Service::Systemd
end
