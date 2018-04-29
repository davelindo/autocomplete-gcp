#!/bin/bash
GCR_HOST=gcr.io
APPLICATION=davelindon/vegeta-stress-test
PROJECT=gcp-autocomplete-davelindon-05
IMAGE=vegeta-stress-test

docker build -t ${APPLICATION} .
docker tag ${APPLICATION} ${GCR_HOST}/${PROJECT}/${IMAGE}
docker push ${GCR_HOST}/${PROJECT}/${IMAGE}
