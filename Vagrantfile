# -*- mode: ruby -*-
# vi: set ft=ruby :
require 'json'

VAGRANTFILE_API_VERSION = "2"
CHEF_VERSION = "12.10.24"
SANDBOX_ROOT = File.dirname(__FILE__)

#Load deploy JSON from separate file.
#Technique referenced from https://github.com/le0pard/chef-solo-example/blob/master/Vagrantfile
CHEF_JSON = JSON.parse(Pathname(__FILE__).dirname.join('deploy.json').read)

Vagrant.require_version ">= 1.6.0"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

    config.omnibus.chef_version = CHEF_VERSION
    config.berkshelf.enabled = true

    config.vm.define :setupmaster do |config|
        config.vm.box = "bento/ubuntu-16.04"
        config.vm.host_name = "setupmaster1"
        config.vm.network "private_network", ip: "192.168.250.11", virtualbox__intnet: "kubernetes"
        config.vm.network "forwarded_port", guest: 8080, host: 8080

        config.vm.provider "virtualbox" do |vm|
            vm.customize ["modifyvm", :id, "--name", "setupmaster1"]
            vm.customize ["modifyvm", :id, "--cpus", 1]
            vm.customize ["modifyvm", :id, "--memory", 2048]
        end

        deploy_json = CHEF_JSON.merge!({
            :kubernetes => {
                :node => {
                    :ip => "192.168.250.11"
                }
            }
        })

        config.vm.provision "bootstrap", type:"chef_solo" do |chef|
            chef.roles_path = "roles"
            chef.add_role "setupmaster_setup"
            chef.json = deploy_json
        end

        config.vm.provision "deploy", type:"chef_solo" do |chef|
            chef.roles_path = "roles"
            chef.add_role "setupmaster_pods"
            chef.json = deploy_json
        end

        config.vm.provision "upgrade_kubernetes", type:"chef_solo" do |chef|
            chef.roles_path = "roles"
            chef.add_role "upgrade_kubernetes"
            chef.json = deploy_json
        end
    end

    config.vm.define :node1 do |config|
        config.vm.box = "bento/ubuntu-16.04"
        config.vm.host_name = "node1"
        config.vm.network "private_network", ip: "192.168.250.12", virtualbox__intnet: "kubernetes"

        config.vm.provider "virtualbox" do |vm|
            vm.customize ["modifyvm", :id, "--name", "node1"]
            vm.customize ["modifyvm", :id, "--cpus", 1]
            vm.customize ["modifyvm", :id, "--memory", 2048]
        end

        deploy_json = CHEF_JSON.merge!({
            :kubernetes => {
                :node => {
                    :ip => "192.168.250.12"
                }
            }
        })

        config.vm.provision "bootstrap", type: "chef_solo" do |chef|
            chef.roles_path = "roles"
            chef.add_role "node_setup"
            chef.json = deploy_json
        end

        ["label_node", "cordon", "uncordon", "upgrade_kubernetes"].each do |provision_type|
            config.vm.provision provision_type, type: "chef_solo" do |chef|
                chef.roles_path = "roles"
                chef.add_role provision_type
                chef.json = deploy_json
            end
        end

    end

    config.vm.define :node2 do |config|
        config.vm.box = "bento/ubuntu-16.04"
        config.vm.host_name = "node2"
        config.vm.network "private_network", ip: "192.168.250.13", virtualbox__intnet: "kubernetes"

        config.vm.provider "virtualbox" do |vm|
            vm.customize ["modifyvm", :id, "--name", "node2"]
            vm.customize ["modifyvm", :id, "--cpus", 1]
            vm.customize ["modifyvm", :id, "--memory", 1024]
        end

        deploy_json = CHEF_JSON.merge!({
            :kubernetes => {
                :node => {
                    :ip => "192.168.250.13"
                }
            }
        })

        config.vm.provision "bootstrap", type: "chef_solo" do |chef|
            chef.roles_path = "roles"
            chef.add_role "node_setup"
            chef.json = deploy_json
        end

        ["label_node", "cordon", "uncordon", "upgrade_kubernetes"].each do |provision_type|
            config.vm.provision provision_type, type: "chef_solo" do |chef|
                chef.roles_path = "roles"
                chef.add_role provision_type
                chef.json = deploy_json
            end
        end
    end

    config.vm.define :node3 do |config|
        config.vm.box = "bento/ubuntu-16.04"
        config.vm.host_name = "node3"
        config.vm.network "private_network", ip: "192.168.250.14", virtualbox__intnet: "kubernetes"

        config.vm.provider "virtualbox" do |vm|
            vm.customize ["modifyvm", :id, "--name", "node3"]
            vm.customize ["modifyvm", :id, "--cpus", 1]
            vm.customize ["modifyvm", :id, "--memory", 1024]
        end

        deploy_json = CHEF_JSON.merge!({
            :kubernetes => {
                :node => {
                    :ip => "192.168.250.14"
                }
            }
        })

        config.vm.provision "bootstrap", type: "chef_solo" do |chef|
            chef.roles_path = "roles"
            chef.add_role "node_setup"
            chef.json = deploy_json
        end

        ["label_node", "cordon", "uncordon", "upgrade_kubernetes"].each do |provision_type|
            config.vm.provision provision_type, type: "chef_solo" do |chef|
                chef.roles_path = "roles"
                chef.add_role provision_type
                chef.json = deploy_json
            end
        end
    end

    config.vm.define :docker_registry do |config|
        config.vm.box = "bento/ubuntu-16.04"
        config.vm.host_name = "docker-registry"
        config.vm.network "private_network", ip: "192.168.250.15", virtualbox__intnet: "kubernetes"

        config.vm.provider "virtualbox" do |vm|
            vm.customize ["modifyvm", :id, "--name", "docker_registry"]
            vm.customize ["modifyvm", :id, "--cpus", 1]
            vm.customize ["modifyvm", :id, "--memory", 1024]
        end

        config.vm.provision "chef_solo" do |chef|
            chef.roles_path = "roles"
            chef.add_role "docker_registry"
            chef.json = CHEF_JSON
        end
    end

end
