# log "curl -f #{node['kubernetes']['etcd']['master_url']}/v2/keys#{node['kubernetes']['etcd']['network_prefix']}"

execute "Create etcd network definition" do
    command "#{node['kubernetes']['etcd']['bindir']}/#{node['kubernetes']['etcd']['etcdctl']['progname']} mk #{node['kubernetes']['etcd']['network_prefix']}/config '{\"Network\":\"#{node['kubernetes']['etcd']['network']}\", \"Backend\":{\"Type\":\"vxlan\"}}'"
    not_if "curl -f #{node['kubernetes']['etcd']['master_url']}/v2/keys#{node['kubernetes']['etcd']['network_prefix']}"
end
