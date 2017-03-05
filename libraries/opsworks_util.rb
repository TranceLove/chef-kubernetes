def opsworks_stack_dump
    Chef::Log.info("Dumping data bags for the layers of the Opsworks stack")

    if defined?(search) && search("aws_opsworks_layer")
        search("aws_opsworks_layer").each do |layer_data|
            Chef::Log.info(layer_data)
        end
    end

    Chef::Log.info("Dumping data bags for the instances of the Opsworks stack")

    if defined?(search) && search("aws_opsworks_instance")
        search("aws_opsworks_instance").each do |instance_data|
            Chef::Log.info(instance_data)
        end
    end
end

def opsworks_find_neighbours_in_layer(status="online")
    role = opsworks_get_instance_databag().role
    return search("aws_opsworks_instance", "role:#{role.first} AND status:online")
end

def opsworks_get_instance_databag
    begin
        return search("aws_opsworks_instance", "hostname:#{node['hostname']}").first
    rescue
        return nil
    end
end
