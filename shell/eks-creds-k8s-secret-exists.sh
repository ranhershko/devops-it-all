#!/bin/bash -x
kubectl get secret eks-creds|grep -v NAME|wc -l
