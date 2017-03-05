if ::File.exists?("#{node['kubernetes']['default_user_home']}/server")
    Chef::Log.info("Kubernetes user exist, proceeding")

    remote_file "#{Chef::Config[:file_cache_path]}/kubernetes-server-linux-amd64.tar.gz" do
        source node['kubernetes']['download_url']
        Chef::Log.info("Download kubernetes.tar.gz version #{node['kubernetes']['version']} from Google (#{node['kubernetes']['download_url']})")
    end

    bash "Extract kubernetes to #{node['kubernetes']['default_user_home']}" do
        cwd Chef::Config[:file_cache_path]
        code <<-EOF
    	tar xf kubernetes-server-linux-amd64.tar.gz
        mv #{node['kubernetes']['default_user_home']}/server #{node['kubernetes']['default_user_home']}/server.old
    	mv kubernetes/server #{node['kubernetes']['default_user_home']}
        rm -rf #{node['kubernetes']['default_user_home']}/server.old
        EOF
    end

    execute "Fix ownership of kubernetes binaries" do
        command "chown -R #{node['kubernetes']['default_user']}:#{node['kubernetes']['default_group']} server"
        cwd node['kubernetes']['default_user_home']
    end

    ['apiserver', 'controller_manager', 'scheduler', 'proxy', 'kubelet'].each do |service|
        service node['kubernetes'][service]['service_name'] do
            action :restart
            provider Chef::Provider::Service::Systemd
            only_if { ::File.exists?(node['kubernetes'][service]['systemdfile']) }
        end
    end

else
    Chef::Log.warn("Kubernetes not installed, skipping upgrade")
end
