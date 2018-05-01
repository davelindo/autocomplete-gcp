#!/bin/bash
gcloud config set container/use_v1_api false
gcloud beta container clusters get-credentials $(gcloud container clusters list |tail -n 1 | awk {'print $1'}) --region us-west1
