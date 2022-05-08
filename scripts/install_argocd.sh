minikube start

# install argocd
kubectl create namespace argocd
kubens argocd
kubectl apply -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
kubectl patch svc argocd-server -p '{"spec": {"type": "LoadBalancer"}}'
