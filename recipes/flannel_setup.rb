remote_file "#{Chef::Config[:file_cache_path]}/flannel.tar.gz" do
    source node['kubernetes']['flannel']['download_url']
    not_if { ::File.exists?("#{node['kubernetes']['flannel']['bindir']}/#{node['kubernetes']['flannel']['progname']}") }
end

directory node['kubernetes']['flannel']['bindir'] do
    action :create
    not_if { ::File.exists?("#{node['kubernetes']['flannel']['bindir']}/#{node['kubernetes']['flannel']['progname']}") }
end

bash "Extract flannel to #{node['kubernetes']['flannel']['bindir']}" do
    cwd Chef::Config[:file_cache_path]
    code <<-EOF
      tar xvf flannel.tar.gz
      mv #{node['kubernetes']['flannel']['progname']} #{node['kubernetes']['flannel']['bindir']}
    EOF
    not_if { ::File.exists?("#{node['kubernetes']['flannel']['bindir']}/#{node['kubernetes']['flannel']['progname']}") }
end

template node['kubernetes']['flannel']['envfile'] do
    source "flannel/default"
end

node_ip = node_private_ip()
etcdhost = get_master_hosts(node['kubernetes']['etcd']['listen_port'])

template node['kubernetes']['flannel']['systemdfile'] do
    source "flannel/systemd-conf.erb"
    variables ({
        :envfile => node['kubernetes']['flannel']['envfile'],
        :bindir => node['kubernetes']['flannel']['bindir'],
        :progname => node['kubernetes']['flannel']['progname'],
        :etcdhost => etcdhost,
        :etcd_prefix => node['kubernetes']['etcd']['network_prefix'],
        :node_ip => node_ip,
        :user => node['kubernetes']['flannel']['user']
    })
end

service node['kubernetes']['flannel']['service_name'] do
    provider Chef::Provider::Service::Systemd
    action [:enable, :start]
end
