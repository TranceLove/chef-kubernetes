instance_data = opsworks_get_instance_databag()
kube_master_url = get_master_hosts(node['kubernetes']['apiserver']['bind_port'], true)

node_ip = instance_data != nil ? instance_data['private_dns'] : node_private_ip()
instance_id = instance_data != nil ? instance_data['instance_id'] : node_ip

execute "Uncordon instance: #{node_ip}(InstanceID=#{instance_id})" do
    command "#{node['kubernetes']['bin_dir']}/kubectl uncordon #{node_ip} --server=#{kube_master_url}"
    user node['kubernetes']['default_user']
    cwd node['kubernetes']['default_user_home']
    environment "HOME" => node['kubernetes']['default_user_home']
end
