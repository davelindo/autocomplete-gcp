#!/bin/bash
for application in dataloader autocomplete-app elasticsearch kibana redis admins;
do
  kubectl delete -f ${application}
done
