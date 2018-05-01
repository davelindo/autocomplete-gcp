# Google Cloud Platform Autocomplete Demo
## Overview
This repo contains the required terraform and kubernetes configuration files to deploy the following:
- Google Project
- Google Global Anycast IP
- Google Cloud DNS Zone
- One (or more) Kubernetes clusters utilizing preemptive nodes
- Kubernetes Infrastructure
 - Elasticsearch
   - Kibana
   - Cerebro
   - Dataloader tool
 - Redis
   - Master
   - Slave
 - Autocomplete App (Python Flask based)
 - HTTP Stress tester

## Preequisites
- Terraform > 0.11
- Gcloud API
- kubectl

## Installation

1. Edit the terraform variables.tf to suit your needs
2. Plan & then apply your changes (this assumes local terraform state)
```bash
$ terraform init
$ terraform plan
$ terraform apply
```
3. If you chose to create a managed zone you may need to set your nameservers appropriately
4. Enable beta container APIs within the Cloud SDK. Grab kubectl configuration
```bash
$ gcloud config set container/use_v1_api false
$ gcloud beta container clusters get-credentials $(gcloud container clusters list |tail -n 1 | awk {'print $1'}) --region us-west1
```
5. Deploy kubernetes infrastructure
```bash
$ cd ../k8s/
$ ./deploy.sh
```
6. Check Pod status
```bash
$ kubectl get pods
```

## Visibility
The cluster installs with the following visibility tooling:
- [Google stackdriver](https://app.google.stackdriver.com/) (requires additional account signup)
  - [Stackdriver Logging](https://console.cloud.google.com/logs/)
  - [Stackdriver Error](https://console.cloud.google.com/errors)
- Elasticsearch Visibility
  - Cerebro (HUD) 
  - Kibana

### Kubeproxy access
In order to access some services the use of kubeproxy is neccesary.
```bash
kubectl proxy --port=8080 &
```
Access the services through the proxy:
- http://127.0.0.1:8080/api/v1/namespaces/default/services/kibana/proxy/
- http://127.0.0.1:8080/api/v1/namespaces/default/services/cerebro/proxy/#/overview?host=http:%2F%2Felasticsearch:9200

## Stress testing
A stresstest job has been created to stress test the deployment.
```bash
cd ./k8s/stresstest
kubectl create -f .
```