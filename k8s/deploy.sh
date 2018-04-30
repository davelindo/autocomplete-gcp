#!/bin/bash
for application in admins elasticsearch redis kibana autocomplete-app;
do
  kubectl apply -f ${application}
done
#Deploy dataloader, only when elasticsearch is green
kubectl proxy --port=8080 &
KUBEPROXYPID=${!}
echo $KUBEPROXYPORT $KUBEPROXYPID
kill $KUBEPROXYPID
