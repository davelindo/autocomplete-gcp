#!/bin/bash
set -e
echo "rolling out new images"
kubectl rolling-update autocomplete-frontend --image=gcr.io/gcp-autocomplete-davelindon-05/autocomplete:latest --image-pull-policy=Always

#https://github.com/kubernetes/contrib/issues/1680
BACKENDS=$(kubectl get ingress autocomplete-frontend -o json | jq -rc '.metadata.annotations."ingress.kubernetes.io/backends" | fromjson | keys | .[]')
for backend in $BACKENDS; do
  SERVICE_NAME=$(gcloud compute backend-services describe --global --format=json "${backend}" | jq -r '.description | fromjson | ."kubernetes.io/service-name"')
  if [[ "$SERVICE_NAME" == *"$2" ]]
  then
      echo "enabling Cloud CDN for backend $backend"
      gcloud compute backend-services update --global "${backend}" --enable-cdn
  fi
done