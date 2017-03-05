# chef-kubernetes
My little toolbox for bringing up a Kubernetes cluster, either on Vagrant or AWS Opsworks

This cookbook is created to automate the setup of a Kubernetes cluster, including master and minion nodes. Aside, there are also recipes that can drain, cordon/uncordon minions, upgrade Kubernetes binaries, as well as setting up a private Docker image repository.

The idea of this cookbook was a result of these needs:

 - Learn Kubernetes the hard way
 - Build Kubernetes on Ubuntu instead of CoreOS
 - Automated setup process on VirtualBox or AWS Opsworks using Chef (Bare metal may do as well, though not tested)

More documentation will be followed. In the meantime, you may look at the Vagrantfile, JSON files under `roles` directory for some ideas on using this cookbook.

Feel free to fork this repository, tune to your needs, and start building your own Kubernetes cluster :)

###Some TODOS

 - Documentation
 - Refactor code to use Ruby Modules
 - Add TLS support
