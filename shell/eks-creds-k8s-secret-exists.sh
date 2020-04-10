#!/bin/bash -x
kubectl get secret eks-creds --namespace=management|grep -v NAME|wc -l
