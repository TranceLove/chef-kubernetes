configfiles = ["grafana-service", "heapster-controller", "heapster-service", "influxdb-grafana-controller", "influxdb-service"]

master_private_ip = node_private_ip()
kube_master_url = "http://#{master_private_ip}:#{node['kubernetes']['apiserver']['bind_port']}"

directory "#{Chef::Config[:file_cache_path]}/influxdb" do
    user node['kubernetes']['default_user']
    group node['kubernetes']['default_group']
    mode "0755"
    action :create
end

configfiles.each do |configfile|
    template "#{Chef::Config[:file_cache_path]}/influxdb/#{configfile}.yaml" do
        source "kubernetes/addons/cluster-monitoring/influxdb/#{configfile}.yaml.erb"
        mode "0644"
        user node['kubernetes']['default_user']
        group node['kubernetes']['default_group']
        variables ({
            :service_type => node['kubernetes']['heapster']['service']['type'],
            :master_url => kube_master_url
        })
    end
end

execute "Deploy pods to Kube" do
    command "#{node['kubernetes']['bin_dir']}/kubectl create -f #{Chef::Config[:file_cache_path]}/influxdb --server=#{kube_master_url}"
    user node['kubernetes']['default_user']
    cwd node['kubernetes']['default_user_home']
    environment "HOME" => node['kubernetes']['default_user_home']
    ignore_failure true
end
