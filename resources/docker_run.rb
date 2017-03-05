resource_name :docker_run

actions :create, :delete
default_action :create

attribute :image, :kind_of=>String, :required=> true
attribute :tag, :kind_of=>String, :required=> false, :default=>"latest"
attribute :environment, :kind_of=>Hash, :required=> false, :default=>nil
attribute :port_mapping, :kind_of=>Hash, :required=> false, :default=>nil
attribute :volumes, :kind_of=>Hash, :required=> false, :default=>nil
attribute :restart, :kind_of=>String, :required=>false, :default=>"always"

action :create do
    _environment = ""
    if(environment != nil && !environment.to_a.empty?)
        _environment = environment.map { |k, v|
            "-e #{k}=#{v}"
        }.join(" ")
    end

    _port_mapping = ""
    if(port_mapping != nil && !port_mapping.to_a.empty?)
        _port_mapping = port_mapping.map { |hostport,guestport|
            "-p #{hostport}:#{guestport}"
        }.join(" ")
    end

    _volumes = ""
    if(volumes != nil && !volumes.to_a.empty?)
        _volumes = volumes.map { |hostdir,guestdir|
            "-v #{hostdir}:#{guestdir}"
        }.join(" ")
    end

    _command = "#{node['docker']['bin']} run -d --restart=#{restart} --name=#{name} #{_environment} #{_port_mapping} #{_volumes} #{image}:#{tag}"
    puts _command

    execute "Run docker image: #{image}:#{tag} as #{name}" do
        command _command
        not_if "#{node['docker']['bin']} | grep '#{image}.*#{name}'"
    end

end
