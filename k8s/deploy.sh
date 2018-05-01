#!/bin/bash
for application in admins elasticsearch redis kibana autocomplete-app; do
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
kill $KUBEPROXYPID
for application in dataloader; do
  kubectl apply -f ${application}
done