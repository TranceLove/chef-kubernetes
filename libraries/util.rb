def kubernetes_repo_setup
    remote_file "#{Chef::Config[:file_cache_path]}/kubernetes-apt.key" do
        source node['kubernetes']['apt_key_url']
    end

    execute "apt-key for kubernetes repo" do
        command "apt-key add #{Chef::Config[:file_cache_path]}/kubernetes-apt.key"
    end

    file "/etc/apt/sources.list.d/kubernetes.list" do
        content "deb http://apt.kubernetes.io/ kubernetes-xenial main"
        mode "0644"
        action :create
    end
end

def create_kube_user
    user "#{node['kubernetes']['default_user']}" do
        comment 'Kubernetes user'
        home "#{node['kubernetes']['default_user_home']}"
        gid node['kubernetes']['default_group']
        shell '/bin/bash'
        manage_home true
        action :create
    end

    execute "Add server/bin to PATH for kube account" do
        command "echo \"export PATH=$PATH:#{node['kubernetes']['default_user_home']}/server/bin\" >> #{node['kubernetes']['default_user_home']}/.profile"
    end
end

def update_apt_cache
    execute "Update apt cache" do
        command "apt-get update"
        ignore_failure true
    end
end

def node_private_ip
    if node['opsworks']
        return node['opsworks']['instance']['private_ip']
    elsif opsworks_get_instance_databag() != nil
        instance_data = opsworks_get_instance_databag()
        return instance_data['private_ip']
    else
        return node['kubernetes']['node']['ip']
    end
end

#FIXME: Allow specifying https
def get_master_hosts(service_port, first_only=false)
    if defined?(search) && node['kubernetes']['master_tier']
        instances = search("aws_opsworks_instance", "role:#{node['kubernetes']['master_tier']} AND status:online")
        if(true == first_only)
            instance = instances.first
            return "http://#{instance['private_ip']}:#{service_port}"
        end
        retval = instances.map { |instance| "http://#{instance['private_ip']}:#{service_port}" }
        return retval.join(",")
    elsif node['kubernetes']['master'] && node['kubernetes']['master']['ip']
        return "http://#{node['kubernetes']['master']['ip']}:#{service_port}"
    else
        return "http://localhost:#{service_port}"
    end
end

def prepare_svc_account_key
    directory node["kubernetes"]["tls_dir"] do
        user node['kubernetes']['default_user']
        group node['kubernetes']['default_group']
        mode "0750"
        action :create
        recursive true
    end

    package "openssl" do
        action :upgrade
    end

    file node["kubernetes"]["service_account_key"]["file"] do
        Chef::Log.info("Using provided PEM as service account key.")
        content node["kubernetes"]["service_account_key"]["pem"]
        user node['kubernetes']['default_user']
        group node['kubernetes']['default_group']
        mode "0660"
        only_if { node["kubernetes"]["service_account_key"]["pem"] }
    end

    execute "Generate SSL key for Kubernetes service account" do
        Chef::Log.info("No PEM provided, generate new key as service account key")
        command <<-EOS
            openssl genrsa -out #{node["kubernetes"]['service_account_key']['file']} #{node["kubernetes"]['service_account_key']['strength']}
            chown #{node['kubernetes']['default_user']}:#{node['kubernetes']['default_group']} #{node["kubernetes"]['service_account_key']['file']}
            chmod 660 #{node["kubernetes"]['service_account_key']['file']}
        EOS
        not_if { node["kubernetes"]["service_account_key"]["pem"] }
    end
end

# def prepare_certs
#     certs_base = node["kubernetes"]["tls_dir"]
#     directory certs_base do
#         user node['kubernetes']['default_user']
#         group node['kubernetes']['default_group']
#         mode "0750"
#         action :create
#         recursive true
#     end
#
#     ["ca.crt", "ca.key", "server.crt", "server.key"].each do |tlsfile|
#         cookbook_file "#{certs_base}/#{tlsfile}" do
#             owner node['kubernetes']['default_user']
#             group node['kubernetes']['default_group']
#             source "tls/#{tlsfile}"
#             not_if { ::File.exists?("#{certs_base}/#{tlsfile}") }
#             mode "0640"
#         end
#     end
# end
