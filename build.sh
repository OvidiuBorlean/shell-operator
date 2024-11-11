docker build -t shellops .
docker tag shellops ovidiuborlean/shellops
docker push ovidiuborlean/shellops
kubectl delete -f ./pod.yaml
kubectl apply -f ./pod.yaml
