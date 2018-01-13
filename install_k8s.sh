# All of this seems idempotent, except
# - kubeadm init (at least the pre-fiight checks fail if it's already installed)
set -ueo pipefail

# get in line
apt update
apt dist-upgrade -y
apt install -y apt-transport-https ca-certificates curl software-properties-common
grep -v swap /etc/fstab > /tmp/fstab && mv /tmp/fstab /etc/fstab
swapoff -a

# Container engine - choose docker, rkt, etc
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
apt-add-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
apt update
apt install -y docker-ce

# == Kubernetes ==
curl -fsSL https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -
apt-add-repository "deb http://apt.kubernetes.io/ kubernetes-xenial main" # yes, xenial. Presumably bionic in future
apt update
apt install -y kubeadm # to install things - it's a master
apt install -y kubelet # it's a worker
apt install -y kubectl # it's an administrator's box

# FIX pod network spec only needed with flannel - everything else does it themselves. Ends up on Node.spec.podCIDR
# Useful to spell them out anyway though
kubeadm init --feature-gates=CoreDNS=true --service-cidr 10.96.0.0/12 --pod-network-cidr 10.244.0.0/16
export KUBECONFIG=/etc/kubernetes/admin.conf

# FIX: k/k#45828; k/kubeadmin#273
sed -i '/KUBELET_DNS_ARGS/ s|"$| --resolv-conf=/run/systemd/resolve/resolv.conf"|' /etc/systemd/system/kubelet.service.d/10-kubeadm.conf

# Would doing a kubeadm join do this too / better?
kubectl taint nodes --all node-role.kubernetes.io/master-

kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml
#kubectl apply -f "https://cloud.weave.works/k8s/net?k8s-version=$(kubectl version | base64 | tr -d '\n')"

matt_home=/home/matt
mkdir -p ${matt_home}/.kube
cp /etc/kubernetes/admin.conf ${matt_home}/.kube/config
chown -R matt:matt ${matt_home}/.kube

kubectl config set-context kubernetes-admin@kubernetes --namespace=kube-system
