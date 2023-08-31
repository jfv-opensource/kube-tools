# Kube-tools

Kube-tools is the source code project of a futur package including some tools to create a kubernetes cluster with few commands only:

* **kc** : *kube controller* - a script to pilot deployments on one more hosts. It connect the target nodes using ssh to run the sequence of commands including package installation and os tuning...
* **km** : *kube master* - a script to deploy a kubernetes master on an host (can be called manually or by kc).
* **kw** : *kube worker* - a script to deploy a kubernetes worker on an host (can be called manually or by kc).
* **klb** : *kube load balancer* - a script to deploy a load balancer on an host (can be called manually or by kc).

The *kube controller* need a package not including by default in distribution, to install it, run the following commands with sudo level:

~~~ bash
add-apt-repository ppa:rmescandon/yq
apt install yq -y
~~~

**Warning**: this code source is distributed as example and should not be used in production. It does not protect agains code injection by example.

## kc - Kube controller

The kube controller pilot the scripts deployed on the differents hosts to deploy and configure the kubernetes cluster from a *yaml* configuration script.

Please note version upgrades is not supported.

### Configuration file

~~~ yaml
kube:
  - version: 1.28
  - network-type: flannel
  - load-balancers:
    - type: nginx
    - servers:
      - server: 1.2.3.4
      - server: 1.2.3.5 
  - workers:
    - server: 2.3.4.5
    - server: 3.3.4.5
  - masters:
    - server: 2.3.4.6
    - server: 3.3.4.6
~~~  

> version [OPTIONNAL]: version of kubernetes to deploy (example 1.28).

> network-type [OPTIONNAL]: the internal kubernetes network type (example: flannel).

The current version only support **flannel**.

> load-balancer > type [OPTIONNAL].

The current version only support **nginx**.

> load-balancer > servers > server [OPTIONNAL] : IP or DNS name of an host to be used as load balancer.

> master > servers > server [MANDATORY] : IP or DNS name of an host to be used as master node.

> workers > servers > server [OPTIONNAL] : IP or DNS name of an host to be used as worker node.

### Command

Usage: kc --dry|--apply|--status|--kubeconfig|--version|--help [--user <user>] [--password <password>] [--ssh-key ssh-key-file] --config Configuration-file

#### Options (exclusives)

 * **--dry**: Run configuration without applying.
 * **--apply**: Run configuration and apply it.
 * **--status**: Display the current status of the kubernetes cluster.
 * **--kubeconfig**: Download kube config file.
 * **--version**: Display version information and exit.
 * **--help**: Display this help and exit.

#### Parameters

 * **--user**: User account to connect hosts using ssh if needed.
 * **--password**: User account password to connect hosts using ssh if needed.
 * **--ssh-key**: Ssh private key file to hosts using ssh if not default.

#### Examples

~~~ bash  
  kc --dry --user admin --config ./config/cluster.yaml
~~~

  Run all operations without applying anything on any hosts using "admin" account on targets.

~~~ bash
  kc --apply --kubeconfig  --user admin --ssh-key ./.ssh/my_key --config ./config/cluster.yaml
~~~

  Run all operations using "admin" account on targets with the ssh private key "mykey".

~~~ bash
  kc --kubeconfig --config ./config/cluster.yaml
~~~

  Get kubeconfig of the cluster.

~~~ bash
  kc --status --config ./config/cluster.yaml
~~~

  Get status of the cluster.

## km - Kube master

The kube master deploys one kubernetes master node. It can be used alone or from a remote *kc* command.

### Command

Usage: km --dry|--apply|--status|--list-networks|--kubeconfig|--version|--help [--mode <mode>] [--network-type <network-type>] [--master-port <port>] [--kube-address <kube-address>] [--first-master] [--master-token <master-token>] [--discovery-hash <discovery-hash>] [--km-token <km-token>]

#### Options (exclusives)

* **--dry**: Run configuration without applying.
* **--apply**: Run configuration and apply it.
* **--status**: Display the current status of the kubernetes cluster.
* **--list-networks**: Display the available network list.
* **--kubeconfig**:  Get kube config file.
* **--generate-join-tokens**: Generate and display tokens to join cluster.
* **--version**: Display version information and exit.
* **--help**: Display this help and exit.

#### Parameters

* **--mode**: Define the master mode (alone, single, multi - default single).
* **--network-type**: Define the kubernetes netw type.
* **--kube-address**: Define the wanted DNS or IP of kubernetes API.
* **--master-port**: Define the kubernetes API port.
* **--first-master**: Define the current master as the first master of the cluster.
* **--master-token**: Define token to join cluster if multi and not first master (example: 0yjqz80dvbljqzxva53).
* **--discovery-hash**: Define discovery hash to join cluster if multi and not first master (example: sha256:4f53c9bc7a89a2fd25d2bdcd2d7f371a93a6e80f60e9b6c71ef5678e977f0cb3
* **--km-token**: Define the km token containing the kube address, the master-token and the discovery-hash

## kw - Kube worker

The kube worker deploys one kubernetes worker node to join an existing cluster. It can be used alone or from a remote *kc* command.

### Command

Usage: kw --dry|--apply|--status|--version|--help [--kube-address <kube-address>] [--master-token <master-token>] [--discovery-hash <discovery-hash>] [--km-token <km-token>]

#### Options (exclusives)

* **--dry**: Run configuration without applying.
* **--apply**: Run configuration and apply it.
* **--status**: Display the current status of the kubernetes cluster.
* **--version**: Display version information and exit.
* **--help**: Display this help and exit.

#### Parameters

* **--kube-address**: Define the wanted DNS or IP of kubernetes API.
* **--master-port**: Define the kubernetes API port.
* **--master-token**: Define token to join cluster if multi and not first master (example: 0yjqz80dvbljqzxva53).
* **--discovery-hash**: Define discovery hash to join cluster if multi and not first master (example: sha256:4f53c9bc7a89a2fd25d2bdcd2d7f371a93a6e80f60e9b6c71ef5678e977f0cb3
* **--km-token**: Define the km token containing the kube address, the master-token and the discovery-hash

## klb - Kube load-balancer

The kube load-balancer deploys one load-balancer to dispatch requests between masters and support master fails. It can be used alone or from a remote *kc* command.

### Command

Usage: klb --dry|--apply|--status|--version|--help|--list-types  --type <type> --master <master1> [--master <master2>] ...

#### Options

 * **--dry**: Run configuration without applying.
 * **--apply**: Run configuration and apply it.
 * **--status**: Display the current status of the kubernetes cluster.
  * **--list-types**: Display supported load-balancing type.
 * **--version**: Display version information and exit.
 * **--help**: Display this help and exit.

#### Parameters

 * **--type**: Define the load balancer type (should not be changed after installation)
 * **--master**: Define a server name or ip to include into load balancing