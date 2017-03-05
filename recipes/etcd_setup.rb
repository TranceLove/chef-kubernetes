remote_file "#{Chef::Config[:file_cache_path]}/etcd.tar.gz" do
    source node['kubernetes']['etcd']['download_url']
    not_if { ::File.exists?("#{node['kubernetes']['etcd']['bindir']}/#{node['kubernetes']['etcd']['progname']}") }
end

directory node['kubernetes']['etcd']['bindir'] do
    action :create
    not_if { ::File.exists?("#{node['kubernetes']['etcd']['bindir']}/#{node['kubernetes']['etcd']['progname']}") }
end

bash "Extract etcd to #{node['kubernetes']['etcd']['bindir']}" do
    cwd Chef::Config[:file_cache_path]
    code <<-EOF
      tar xvf etcd.tar.gz
      cd #{node['kubernetes']['etcd']['filename_prefix']}
      mv etcd #{node['kubernetes']['etcd']['bindir']} && mv etcdctl #{node['kubernetes']['etcd']['bindir']}
    EOF
    not_if { ::File.exists?("#{node['kubernetes']['etcd']['bindir']}/#{node['kubernetes']['etcd']['progname']}") }
end

node_ip = node_private_ip()

template node['kubernetes']['etcd']['envfile'] do
    source "etcd/default.erb"
    variables ({
        :datadir => node['kubernetes']['etcd']['datadir'],
        :logfile => node['kubernetes']['etcd']['logfile'],
        :listen_at => "http://127.0.0.1:#{node['kubernetes']['etcd']['listen_port']},http://#{node_ip}:#{node['kubernetes']['etcd']['listen_port']}",
        :listen_peer_at => "http://#{node_ip}:#{node['kubernetes']['etcd']['peer_listen_port']}",
        :advertise_client_urls => "http://#{node_ip}:#{node['kubernetes']['etcd']['listen_port']}"
    })
end

template node['kubernetes']['etcd']['systemdfile'] do
    source "etcd/initconf.erb"
    variables ({
        :envfile => node['kubernetes']['etcd']['envfile'],
        :bindir => node['kubernetes']['etcd']['bindir'],
        :progname => node['kubernetes']['etcd']['progname'],
        :user => node['kubernetes']['etcd']['user']
    })
end

directory node['kubernetes']['etcd']['datadir'] do
    user node['kubernetes']['etcd']['user']
    group node['kubernetes']['etcd']['group']
    action :create
    not_if { ::File.exists?("#{node['kubernetes']['etcd']['datadir']}") }
end

service node['kubernetes']['etcd']['service_name'] do
    provider Chef::Provider::Service::Systemd
    action [:enable, :start]
end
