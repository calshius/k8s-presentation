# Helm Initialization
kubectl create serviceaccount tiller --namespace kube-system
kubectl create clusterrolebinding tiller-role-binding --clusterrole cluster-admin --serviceaccount=kube-system:tiller
# Installing Prometheus Operator
helm install monitoring stable/prometheus-operator