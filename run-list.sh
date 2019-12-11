# Build cluster using terraform
export TF_VAR_client_id='populate me'
export TF_VAR_client_secret='populate me'
terraform plan
terraform apply -auto-approve
# Create kubeconfig using terraform output
echo "$(terraform output kube_config)" > ~/.kube/config 
# Enable ingress application routing
az aks enable-addons --resource-group azure-k8stest-1 --name k8stest-1 --addons http_application_routing
# Get the cluster id
az aks show --resource-group azure-k8stest-1 --name k8stest-1 --query addonProfiles.httpApplicationRouting.config.HTTPApplicationRoutingZoneName -o table
# Deploy presentation
kubectl apply -f k8s/k8s-presentation.yaml
sleep 5
kubectl expose deployment k8s-presentation
# Port forward the presentation to show one example of accessing it
kubectl port-forward services/k8s-presentation 8000:8000
# Add a proper in gress to it - can take time to be exposed
kubectl apply -f k8s/pres-ingress.yaml
# Helm Initialization
kubectl create serviceaccount tiller --namespace kube-system
kubectl create clusterrolebinding tiller-role-binding --clusterrole cluster-admin --serviceaccount=kube-system:tiller
# Installing Prometheus Operator
helm install monitoring stable/prometheus-operator
# Expose grafana ingress
kubectl apply -f k8s/grafana-ingress.yaml
# Get grafana secret
kubectl get secrets monitoring-grafana -o yaml
# Destroy cluster
terraform destroy -auto-approve
