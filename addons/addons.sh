kubectl create -f https://raw.githubusercontent.com/kubernetes/dashboard/master/src/deploy/recommended/kubernetes-dashboard.yaml

kubectl apply -f https://j.hept.io/contour-deployment-rbac
# kubectl apply -f https://j.hept.io/contour-kuard-example

kubectl create -f --namespace kube-system "https://cloud.weave.works/k8s/scope.yaml?k8s-version=$(kubectl version | base64 | tr -d '\n')"

kubectl create -f --namespace kube-system https://raw.githubusercontent.com/weaveworks/flux/master/deploy/flux-deployment.yaml

kubectl create -f https://raw.githubusercontent.com/kubernetes/heapster/master/deploy/kube-config/influxdb/heapster.yaml
kubectl create -f https://raw.githubusercontent.com/kubernetes/heapster/master/deploy/kube-config/influxdb/grafana.yaml
kubectl create -f https://raw.githubusercontent.com/kubernetes/heapster/master/deploy/kube-config/influxdb/influxdb.yaml
kubectl create -f https://raw.githubusercontent.com/kubernetes/heapster/master/deploy/kube-config/rbac/heapster-rbac.yaml

#kubectl create -f https://raw.githubusercontent.com/kubernetes/kubernetes/master/cluster/addons/cluster-monitoring/influxdb/grafana-service.yaml
#kubectl create -f https://raw.githubusercontent.com/kubernetes/kubernetes/master/cluster/addons/cluster-monitoring/influxdb/heapster-controller.yaml
#kubectl create -f https://raw.githubusercontent.com/kubernetes/kubernetes/master/cluster/addons/cluster-monitoring/influxdb/heapster-service.yaml
#kubectl create -f https://raw.githubusercontent.com/kubernetes/kubernetes/master/cluster/addons/cluster-monitoring/influxdb/influxdb-grafana-controller.yaml
#kubectl create -f https://raw.githubusercontent.com/kubernetes/kubernetes/master/cluster/addons/cluster-monitoring/influxdb/influxdb-service.yaml


kubectl create -f dashbord-service_account.yaml
kubectl create -f dashbord-role_binding.yaml
kubectl describe secret $(kubectl get serviceaccount dashboard -o jsonpath='{.secrets[0].name}')
