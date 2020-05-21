#!/bin/bash -xv

count=0

for vaultServer in `kubectl get pods --namespace=management|grep vault-devopsitall-[0-9]|awk '{print $1}'`; do
  if [ ${count} -eq 0 ]; then
    kubectl exec -ti ${vaultServer}  --namespace=management -c vault -- vault operator init
    count=1
  fi
  kubectl exec -ti ${vaultServer} --namespace=management -c vault -- vault operator unseal
done
  
    
