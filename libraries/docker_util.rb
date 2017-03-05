def add_user_to_docker_group(users = [])
    users.each do |username|
        execute "Add user #{username} to #{node['docker']['group']}" do
            command "usermod -aG #{node['docker']['group']} #{username}"
            not_if "grep #{node['docker']['group']} /etc/group"
        end
    end
end
