#!/bin/bash
GCR_HOST=gcr.io
APPLICATION=davelindon/autocomplete
PROJECT=gcp-autocomplete-davelindon-05
IMAGE=autocomplete

docker build -t ${APPLICATION} .
docker tag ${APPLICATION} ${GCR_HOST}/${PROJECT}/${IMAGE}
docker push ${GCR_HOST}/${PROJECT}/${IMAGE}
