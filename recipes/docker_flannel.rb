template node['docker']['systemdfile'] do
   source "docker/systemd/docker.service.erb"
   variables ({
       :envfile => node['docker']['envfile']
   })
end

execute "systemctl daemon-reload"

template node['docker']['envfile'] do
   source "docker/env/default.erb"
   variables ({
       :insecure_registry => node['docker']['insecure_registry']
   })
end

bash "Patch docker service description with flannel network environment" do
    code <<-EOH
    source #{node['kubernetes']['flannel']['subnet_env']}
    sed -i -e "s|%FLANNEL_SUBNET%|$FLANNEL_SUBNET|" -e "s|%FLANNEL_MTU%|$FLANNEL_MTU|" #{node['docker']['envfile']}
    EOH
    not_if "grep %FLANNEL_SUBNET% #{node['docker']['systemdfile']}"
    notifies :restart, "service[docker]", :immediately
end
