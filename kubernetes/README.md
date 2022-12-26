# kubernetes cluster creation

## docker & containerd
install docker & containerd: https://docs.docker.com/engine/install/ubuntu/
add docker mirror registry: https://blog.miyuru.lk/dockerhub-ipv6/
\# containerd config default > /etc/containerd/config.toml 
setup containerd: https://kubernetes.io/docs/setup/production-environment/container-runtimes/#containerd

## install kubeadm, kubelet and kubectl
https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/install-kubeadm/

## create ipv6 cluster
https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/dual-stack-support/
from control plane (master):
$ sudo swapoff -a
$ sudo kubeadm reset
$ sudo rm -rf /var/lib/cni/
$ sudo rm -rf $HOME/.kube
$ sudo rm -rf /var/lib/calico
$ sudo systemctl daemon-reload
$ sudo iptables -F && sudo iptables -t nat -F && sudo iptables -t mangle -F && sudo iptables -X
$ sudo sysctl -w net.ipv6.conf.all.forwarding=1
$ sudo kubeadm init --config=kubeadm-config.yaml
$ mkdir -p $HOME/.kube
$ sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
$ sudo chown $(id -u):$(id -g) $HOME/.kube/config
$ kubectl taint nodes --all node-role.kubernetes.io/control-plane-

from worker:
$ sudo swapoff -a
$ sudo kubeadm reset
$ sudo rm -rf /var/lib/cni/
$ sudo rm -rf $HOME/.kube
$ sudo rm -rf /var/lib/calico
$ sudo systemctl daemon-reload
$ sudo iptables -F && sudo iptables -t nat -F && sudo iptables -t mangle -F && sudo iptables -X
$ sudo sysctl -w net.ipv6.conf.all.forwarding=1
$ sudo kubectl join <master_ipv6>:6443 --token <token> --discovery-token-ca-cert-hash <hash>

## pod network (calico)
install calico: https://projectcalico.docs.tigera.io/getting-started/kubernetes/self-managed-onprem/onpremises
configure ipv6 network: https://projectcalico.docs.tigera.io/networking/ipv6#enable-dual-stack
from control plane (master):
$ kubectl create -f https://raw.githubusercontent.com/projectcalico/calico/v3.24.5/manifests/tigera-operator.yaml
$ kubectl create -f calico-config.yaml
