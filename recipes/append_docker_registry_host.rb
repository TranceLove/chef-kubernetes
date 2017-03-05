if defined?(search) && search("aws_opsworks_instance")
    #Assume there is one single (1) host as the docker registry, and is on the same stack.
    registry_host_info = search("aws_opsworks_instance", "role:#{node['kubernetes']['docker_registry_tier']}").first
    ip_address = registry_host_info['private_ip']

    hostsfile_entry ip_address do
        hostname    node['docker']['insecure_registry'].split(":")[0]
        unique      true
        action      :create
    end
end
