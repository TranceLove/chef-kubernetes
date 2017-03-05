instance_data = opsworks_get_instance_databag()

kube_master_url = get_master_hosts(node['kubernetes']['apiserver']['bind_port'], true)

if node['kubernetes']['node']['labels']
    label_arg = ""
    node['kubernetes']['node']['labels'].keys.each do |namespace|
        node['kubernetes']['node']['labels'][namespace].each{|key,value|
            label_arg.concat "#{namespace}/#{key}=#{value} "
        }
    end
    if(label_arg.end_with?(" "))
        label_arg = label_arg[0..-2]
    end

    node_ip = instance_data != nil ? instance_data['private_dns'] : node_private_ip()
    instance_id = instance_data != nil ? instance_data['instance_id'] : node_ip

    execute "Attach Kubernetes label to instance: #{node_ip}(InstanceID=#{instance_id})" do
        command "#{node['kubernetes']['bin_dir']}/kubectl label node #{node_ip} --overwrite=true --server=#{kube_master_url} #{label_arg}"
        user node['kubernetes']['default_user']
        cwd node['kubernetes']['default_user_home']
        environment "HOME" => node['kubernetes']['default_user_home']
    end
end
