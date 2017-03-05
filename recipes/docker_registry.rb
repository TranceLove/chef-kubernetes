environment = {}
volumes = {}
if(node['docker']['registry']['tls'] != nil)
    directory node['docker']['registry']['tls']['dir'] do
        group node['docker']['group']
        recursive true
        action :create
    end

    ssl_key_content = node['docker']['registry']['tls']['key']['content']
    ssl_cert_content = node['docker']['registry']['tls']['cert']['content']

    if(ssl_key_content != nil && ssl_key_content != "" && ssl_cert_content != nil && ssl_cert_content != "")
        file node['docker']['registry']['tls']['key']['file'] do
            content ssl_key_content
            group node['docker']['group']
            mode "0660"
            action :create
        end

        file node['docker']['registry']['tls']['cert']['file'] do
            content ssl_cert_content
            group node['docker']['group']
            mode "0660"
            action :create
        end
    elsif(node['docker']['registry']['tls']['key']['source'] != nil && node['docker']['registry']['tls']['cert']['source'] != nil)
        cookbook_file node['docker']['registry']['tls']['key']['file'] do
            source node['docker']['registry']['tls']['key']['source']['file']
            cookbook node['docker']['registry']['tls']['key']['source']['cookbook'] || @cookbook_name.to_s
            group node['docker']['group']
            mode "0660"
            action :create
        end

        cookbook_file node['docker']['registry']['tls']['cert']['file'] do
            source node['docker']['registry']['tls']['cert']['source']['file']
            cookbook node['docker']['registry']['tls']['cert']['source']['cookbook'] || @cookbook_name.to_s
            group node['docker']['group']
            mode "0660"
            action :create
        end
    end

    environment[node['docker']['registry']['tls']['cert']['envname']] = node['docker']['registry']['tls']['guest_cert']
    environment[node['docker']['registry']['tls']['key']['envname']] = node['docker']['registry']['tls']['guest_key']

    volumes[node['docker']['registry']['tls']['dir']] = node['docker']['registry']['tls']['guest_dir']
end

docker_run "registry" do
    image node['docker']['registry']['image']
    tag node['docker']['registry']['tag']
    port_mapping ({
        node['docker']['registry']['host_port'] => node['docker']['registry']['guest_port']
    })
    restart "unless-stopped"
    action :create
    environment environment
    volumes volumes
end
