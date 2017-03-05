master_private_ip = node_private_ip()
kube_master_url = "http://#{master_private_ip}:#{node['kubernetes']['apiserver']['bind_port']}"

template node['kubernetes']['kubedns']['rcpodfile'] do
    source "kubernetes/addons/dns/skydns-rc.yaml.erb"
    mode "0644"
    user node['kubernetes']['default_user']
    group node['kubernetes']['default_group']
    variables ({
        :replicas => node['kubernetes']['kubedns']['pod']['replicas'],
        :dns_domain => node['kubernetes']['cluster']['domain'],
        :kube_master_url => kube_master_url
    })
end

template node['kubernetes']['kubedns']['svcpodfile'] do
    source "kubernetes/addons/dns/skydns-svc.yaml.erb"
    mode "0644"
    user node['kubernetes']['default_user']
    group node['kubernetes']['default_group']
    variables ({
        :cluster_dns_ip => node['kubernetes']['cluster']['dns']
    })
end

execute "Deploy pods to Kube" do
    command "#{node['kubernetes']['bin_dir']}/kubectl create -f #{node['kubernetes']['kubedns']['rcpodfile']} --server=#{kube_master_url} && \
    #{node['kubernetes']['bin_dir']}/kubectl create -f #{node['kubernetes']['kubedns']['svcpodfile']} --server=#{kube_master_url}"
    user node['kubernetes']['default_user']
    cwd node['kubernetes']['default_user_home']
    environment "HOME" => node['kubernetes']['default_user_home']
end
