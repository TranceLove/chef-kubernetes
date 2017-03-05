node_ip = instance_data != nil ? instance_data['private_dns'] : node_private_ip()
instance_id = instance_data != nil ? instance_data['instance_id'] : node_ip

args = ["--timeout #{node['kubernetes']['drain']['args']['timeout']}", "--grace-period #{node['kubernetes']['drain']['args']['grace_period']}"]

if true == node['kubernetes']['drain']['args']['force']
    args << "--force"
end

if true == node['kubernetes']['drain']['args']['delete_local_pod']
    args << "--delete-local-data"
end

if true == node['kubernetes']['drain']['args']['ignore_daemon_sets']
    args << "--ignore-daemonsets"
end

args = args.join(" ")

execute "Drain instance: #{node_ip}(InstanceID=#{instance_id})" do
    command "#{node['kubernetes']['bin_dir']}/kubectl drain #{node_ip} --server=#{kube_master_url} #{args}"
    user node['kubernetes']['default_user']
    cwd node['kubernetes']['default_user_home']
    environment "HOME" => node['kubernetes']['default_user_home']
end
