#!/bin/bash -x
kubectl get secret vault-tls|grep -v NAME|wc -l
