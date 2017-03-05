if(node['docker']['registry']['tls'] != nil)
    directory "#{node['docker']['registry']['tls']['certsd']}/#{node['docker']['insecure_registry']}" do
        group node['docker']['group']
        recursive true
        action :create
    end

    ssl_cert_content = node['docker']['registry']['tls']['cert']['content']

    if(ssl_cert_content != nil && ssl_cert_content != "")
        file "#{node['docker']['registry']['tls']['certsd']}/#{node['docker']['insecure_registry']}/ca.crt" do
            content ssl_cert_content
            group node['docker']['group']
            mode "0660"
            action :create
        end
    elsif(node['docker']['registry']['tls']['cert']['source'] != nil)
        cookbook_file "#{node['docker']['registry']['tls']['certsd']}/#{node['docker']['insecure_registry']}/ca.crt" do
            source node['docker']['registry']['tls']['cert']['source']['file']
            cookbook node['docker']['registry']['tls']['cert']['source']['cookbook'] || @cookbook_name.to_s
            group node['docker']['group']
            mode "0660"
            action :create
        end
    end
end
