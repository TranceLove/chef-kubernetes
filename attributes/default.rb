default['docker']['systemdfile_location'] = "/lib/systemd/system"
default['docker']['systemdfile'] = "#{node['docker']['systemdfile_location']}/docker.service"
default['docker']['envfile'] = "/etc/default/docker"
default['docker']['group'] = "docker"
default['docker']['bin'] = "/usr/bin/docker"
default['docker']['registry']['image'] = "registry"
default['docker']['registry']['tag'] = "2"
default['docker']['registry']['host_port'] = "5000"
default['docker']['registry']['guest_port'] = "5000"
default['docker']['registry']['tls']['dir'] = "/etc/docker/registry/tls"
default['docker']['registry']['tls']['cert']['file'] = "#{node['docker']['registry']['tls']['dir']}/server.crt"
default['docker']['registry']['tls']['cert']['envname'] = "REGISTRY_HTTP_TLS_CERTIFICATE"
default['docker']['registry']['tls']['key']['file'] = "#{node['docker']['registry']['tls']['dir']}/server.key"
default['docker']['registry']['tls']['key']['envname'] = "REGISTRY_HTTP_TLS_KEY"
default['docker']['registry']['tls']['guest_dir'] = "/certs"
default['docker']['registry']['tls']['guest_cert'] = "#{node['docker']['registry']['tls']['guest_dir']}/server.crt"
default['docker']['registry']['tls']['guest_key'] = "#{node['docker']['registry']['tls']['guest_dir']}/server.key"
default['docker']['registry']['tls']['certsd'] = "/etc/docker/certs.d"

default['kubernetes']['default_user'] = "kube"
default['kubernetes']['default_group'] = "root"
default['kubernetes']['default_user_home'] = "/opt/kubernetes"
default['kubernetes']['bin_dir'] = "#{node['kubernetes']['default_user_home']}/server/bin"
default['kubernetes']['systemdfile_location'] = "/lib/systemd/system"
default["kubernetes"]["version"] = "1.4.6"
default["kubernetes"]["config_dir"] = "/etc/kubernetes"
default["kubernetes"]["tls_dir"] = "#{node['kubernetes']['config_dir']}/tls"
default["kubernetes"]["download_url"] = "https://storage.googleapis.com/kubernetes-release/release/v#{node['kubernetes']['version']}/kubernetes-server-linux-amd64.tar.gz"
default["kubernetes"]['apt_key_url'] = "https://packages.cloud.google.com/apt/doc/apt-key.gpg"
default["kubernetes"]['service_account_key']['file'] = "#{node['kubernetes']['tls_dir']}/apiserver.key"
default["kubernetes"]['service_account_key']['strength'] = "2048"

default['kubernetes']['cluster']['network'] = "172.17.0.0/16"
default['kubernetes']['cluster']['service_cluster_ip_range'] = "10.0.0.1/24"

default['kubernetes']['etcd']['listen_port'] = "2379"
default['kubernetes']['etcd']['peer_listen_port'] = "2380"
default['kubernetes']['etcd']['envfile'] = "/etc/default/etcd"
default['kubernetes']['etcd']['systemdfile'] = "#{node['kubernetes']['systemdfile_location']}/etcd.service"
default['kubernetes']['etcd']['service_name'] = "etcd"
default['kubernetes']['etcd']['version'] = "3.0.14"
default['kubernetes']['etcd']['bindir'] = "/opt/bin"
default['kubernetes']['etcd']['progname'] = "etcd"
default['kubernetes']['etcd']['etcdctl']['progname'] = "etcdctl"
default['kubernetes']['etcd']['logfile'] = "/var/log/etcd.log"
default['kubernetes']['etcd']['datadir'] = "/var/lib/etcd"
default['kubernetes']['etcd']['filename_prefix'] = "etcd-v#{node['kubernetes']['etcd']['version']}-linux-amd64"
default['kubernetes']['etcd']['download_url'] = "https://github.com/coreos/etcd/releases/download/v#{node['kubernetes']['etcd']['version']}/#{node['kubernetes']['etcd']['filename_prefix']}.tar.gz"
default['kubernetes']['etcd']['network'] = node['kubernetes']['cluster']['network']
default['kubernetes']['etcd']['local_master_url'] = "http://127.0.0.1:#{node['kubernetes']['etcd']['listen_port']}"
default['kubernetes']['etcd']['user'] = node['kubernetes']['default_user']
default['kubernetes']['etcd']['group'] = node['kubernetes']['default_group']

default['kubernetes']['flannel']['progname'] = "flanneld"
default['kubernetes']['flannel']['version'] = "0.6.2"
default['kubernetes']['flannel']['filename_prefix'] = "flannel-v#{node['kubernetes']['flannel']['version']}-linux-amd64"
default['kubernetes']['flannel']['download_url'] = "https://github.com/coreos/flannel/releases/download/v#{node['kubernetes']['flannel']['version']}/#{node['kubernetes']['flannel']['filename_prefix']}.tar.gz"
default['kubernetes']['flannel']['bindir'] = "/opt/bin"
default['kubernetes']['flannel']['envfile'] = "/etc/default/flannel"
default['kubernetes']['flannel']['systemdfile'] = "#{node['kubernetes']['systemdfile_location']}/flannel.service"
default['kubernetes']['flannel']['service_name'] = "flannel"
default['kubernetes']['flannel']['logdir'] = "/var/log/flannel"
default['kubernetes']['flannel']['user'] = node['kubernetes']['default_user']
default['kubernetes']['flannel']['group'] = node['kubernetes']['default_group']
default['kubernetes']['flannel']['subnet_env'] = "/run/flannel/subnet.env"

default["kubernetes"]["kubelet"]['port'] = "10250"
default["kubernetes"]["kubelet"]['workdir'] = "/var/lib/kubelet"
default['kubernetes']['kubelet']['service_name'] = "kubelet"
default['kubernetes']['kubelet']['systemdfile'] = "#{node['kubernetes']['systemdfile_location']}/kubelet.service"

default['kubernetes']['apiserver']['bind_address'] = "0.0.0.0"
default['kubernetes']['apiserver']['bind_port'] = "8080"
default['kubernetes']['apiserver']['secure_bind_port'] = "6443"
default['kubernetes']['apiserver']['systemdfile'] = "#{node['kubernetes']['systemdfile_location']}/kube-apiserver.service"
default['kubernetes']['apiserver']['service_name'] = "kube-apiserver"

default['kubernetes']['controller_manager']['service_name'] = "kube-controller-manager"
default['kubernetes']['controller_manager']['systemdfile'] = "#{node['kubernetes']['systemdfile_location']}/kube-controller-manager.service"

default['kubernetes']['scheduler']['service_name'] = "kube-scheduler"
default['kubernetes']['scheduler']['systemdfile'] = "#{node['kubernetes']['systemdfile_location']}/kube-scheduler.service"

default['kubernetes']['proxy']['service_name'] = "kube-proxy"
default['kubernetes']['proxy']['systemdfile'] = "#{node['kubernetes']['systemdfile_location']}/kube-proxy.service"

default['kubernetes']['kubedns']['systemdfile'] = "#{node['kubernetes']['systemdfile_location']}/kube-dns.service"
default['kubernetes']['kubedns']['listen_port'] = "10053"
default['kubernetes']['kubedns']['log_dir'] = "/var/log/kubernetes/kubedns"
default['kubernetes']['kubedns']['service_name'] = "kube-dns"
default['kubernetes']['kubedns']['pod']['replicas'] = "1"
default['kubernetes']['kubedns']['rcpodfile'] = "#{Chef::Config[:file_cache_path]}/skydns-rc.yaml"
default['kubernetes']['kubedns']['svcpodfile'] = "#{Chef::Config[:file_cache_path]}/skydns-svc.yaml"

default['kubernetes']['heapster']['service']['type'] = "NodePort"

default['kubernetes']['dashboard']['podfile'] = "#{Chef::Config[:file_cache_path]}/kubernetes-dashboard.yaml"

default['kubernetes']['drain']['args']['grace_period'] = -1
default['kubernetes']['drain']['args']['timeout'] = 0
