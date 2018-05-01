#!/bin/bash
for application in admins elasticsearch redis kibana; do
  kubectl apply -f ${application}
done
#Deploy dataloader, only when elasticsearch is green
kubectl proxy --port=35432 &
KUBEPROXYPID=${!}
number_of_nodes=0
echo "Waiting for cerebro deployment..."
sleep 30
until (( number_of_nodes > 4 )); do
  number_of_nodes=$(curl --silent -d '{"host": "http://elasticsearch:9200"}' -H "Content-Type: application/json" -X POST http://127.0.0.1:35432/api/v1/namespaces/default/services/cerebro/proxy/overview | jq '.body.number_of_nodes' -r)
  echo "Waiting for elasticsearch to have more than 4 nodes ready (currently ${number_of_nodes})"
  sleep 10
done
for application in dataloader autocomplete-app; do
  kubectl apply -f ${application}
done
ingress_backend=''
until grep -q "k8s" <<< "${ingress_backend}" ; do
  #https://github.com/kubernetes/ingress-gce/blob/master/docs/faq/gce.md#can-i-configure-gce-health-checks-through-the-ingress
  echo "Waiting for ingress controller to deploy a backend to change the health check interval..."
  ingress_backend=$(kubectl get ingress autocomplete-frontend -o json | jq '.metadata.annotations."ingress.kubernetes.io/backends" | fromjson| keys[]' -r)
  sleep 10
done

#Set timeout and check interval
gcloud compute health-checks update http ${ingress_backend} --check-interval 10s --timeout 5s

kill $KUBEPROXYPID

until (( $(curl -sL -w "%{http_code}\\n" "http://ingress.gcp.davelindon.me/healthcheck" -o /dev/null) == 200 ));
do
  echo "Waiting for the Global Load Balancer to provision..."
  sleep 15
done

echo "Beginning stress test"
for application in stresstest; do
  kubectl apply -f ${application}
done
