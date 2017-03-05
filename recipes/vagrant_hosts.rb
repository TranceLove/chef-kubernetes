hostsfile_entry '192.168.250.11' do
    hostname    'setupmaster1'
    unique      true
    action      :create
end

hostsfile_entry '192.168.250.12' do
    hostname    'node1'
    unique      true
    action      :create
end

hostsfile_entry '192.168.250.13' do
    hostname    'node2'
    unique      true
    action      :create
end

hostsfile_entry '192.168.250.14' do
    hostname    'node3'
    unique      true
    action      :create
end
