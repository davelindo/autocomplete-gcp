#!/bin/bash
GCR_HOST=gcr.io
APPLICATION=davelindon/dataloader
PROJECT=gcp-autocomplete-davelindon-05
IMAGE=dataloader

docker build -t ${APPLICATION} .
docker tag ${APPLICATION} ${GCR_HOST}/${PROJECT}/${IMAGE}
docker push ${GCR_HOST}/${PROJECT}/${IMAGE}
