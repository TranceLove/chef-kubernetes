#During development, use local supplied copy instead of downloading the 1.2GB distribution tarball every time.
cookbook_file "#{Chef::Config[:file_cache_path]}/kubernetes-server-linux-amd64.tar.gz" do
    source "kubernetes-server-linux-amd64.tar.gz"
    Chef::Log.info("Using local copy of kubernetes.tar.gz")
    only_if { run_context.has_cookbook_file_in_cookbook?(cookbook_name, "kubernetes-server-linux-amd64.tar.gz") && !::File.directory?("#{node['kubernetes']['default_user_home']}/server") }
end

remote_file "#{Chef::Config[:file_cache_path]}/kubernetes-server-linux-amd64.tar.gz" do
    source node['kubernetes']['download_url']
    Chef::Log.info("Using kubernetes.tar.gz from Google")
    not_if { run_context.has_cookbook_file_in_cookbook?(cookbook_name, "kubernetes-server-linux-amd64.tar.gz") || ::File.directory?("#{node['kubernetes']['default_user_home']}/server") }
end

bash "Extract kubernetes to #{node['kubernetes']['default_user_home']}" do
    cwd Chef::Config[:file_cache_path]
    code <<-EOF
	tar xf kubernetes-server-linux-amd64.tar.gz
	mv kubernetes/server #{node['kubernetes']['default_user_home']}
    EOF
    not_if { ::File.exists?("#{node['kubernetes']['default_user_home']}/server") }
end

execute "Fix ownership of kubernetes binaries" do
    command "chown -R #{node['kubernetes']['default_user']}:#{node['kubernetes']['default_group']} server"
    cwd node['kubernetes']['default_user_home']
end

directory node['kubernetes']['config_dir'] do
    user "root"
    group "root"
    mode "0755"
    action :create
    not_if { ::File.exists?("#{node['kubernetes']['config_dir']}") }
end

private_ip = node_private_ip()
kube_master_url = get_master_hosts(node['kubernetes']['apiserver']['bind_port'], true)

template "#{node['kubernetes']['config_dir']}/config" do
    source "kubernetes/systemd/environ/config.erb"
    user "root"
    group "root"
    mode "0644"
    variables ({
        :kube_master_url => kube_master_url
    })
end

directory "/etc/systemd/tmpfiles.d" do
    user "root"
    group "root"
    mode "0755"
    action :create
    not_if { ::File.exists?("/etc/systemd/tmpfiles.d") }
end

template "/etc/systemd/tmpfiles.d/kubernetes.conf" do
    source "kubernetes/systemd/tmpfiles.d/kubernetes.conf"
    user "root"
    group "root"
    mode "0644"
end
