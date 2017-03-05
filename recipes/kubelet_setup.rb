template node['kubernetes']['kubelet']['systemdfile'] do
    source "kubernetes/systemd/kubelet.service"
    mode "0644"
    user "kube"
    group "root"
end

# ruby_block "Detect machine IP" do
#     block do
#         puts node['kubernetes']
#         node['network']['interfaces'].keys.each do |iface|
#             node_ip = node['network']['interfaces'][iface]['addresses'].detect{ |address,info| info['broadcast'] == "#{node['kubernetes']['node']['broadcast']}"}
#             if(node_ip != nil)
#                 puts node_ip[0]
#                 node.run_state['this_ip'] = node_ip[0]
#                 break
#             end
#         end
#     end
# end

node_ip = node_private_ip()
if(node['kubernetes']['kubelet']['post_opsworks_internal_dns_name'])
    node_ip = opsworks_get_instance_databag()['private_dns']
    Chef::Log.info("Node IP: #{node_ip}")
end
apiserverhost = get_master_hosts(node['kubernetes']['apiserver']['bind_port'])

template "#{node['kubernetes']['config_dir']}/kubelet" do
    source "kubernetes/systemd/environ/kubelet.erb"
    user "kube"
    group "root"
    mode "0644"
    variables ({
        :apiserver_url => apiserverhost,
        :kubelet_address => node_ip,
        :kubelet_port => node["kubernetes"]["kubelet"]['port'],
        :cluster_dns => node["kubernetes"]["cluster"]["dns"],
        :cluster_domain => node["kubernetes"]["cluster"]["domain"]
    })
end

directory node["kubernetes"]["kubelet"]['workdir'] do
    user node['kubernetes']['default_user']
    group node['kubernetes']['default_group']
    mode "0755"
    action :create
end

service node['kubernetes']['kubelet']['service_name'] do
    action [:enable, :start]
    provider Chef::Provider::Service::Systemd
end
