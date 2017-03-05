master_private_ip = node_private_ip()
kube_master_url = "http://#{master_private_ip}:#{node['kubernetes']['apiserver']['bind_port']}"

template node['kubernetes']['dashboard']['podfile'] do
    source "kubernetes/addons/dashboard/kubernetes-dashboard.yaml.erb"
    mode "0644"
    user node['kubernetes']['default_user']
    group node['kubernetes']['default_group']
    variables ({
        :kube_master_url => kube_master_url
    })
end

execute "Deploy pods to Kube" do
    command "#{node['kubernetes']['bin_dir']}/kubectl create -f #{node['kubernetes']['dashboard']['podfile']} --server=#{kube_master_url}"
    user node['kubernetes']['default_user']
    cwd node['kubernetes']['default_user_home']
    environment "HOME" => node['kubernetes']['default_user_home']
end
