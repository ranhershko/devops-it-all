#!/bin/bash -x
app=$1
kubectl get secret ${app}-tls -n management|grep -v NAME|wc -l
#if [ "$app" == "vault" ]
#then
  #kubectl get secret ${app}-tls -n ${app}|grep -v NAME|wc -l
#else
  #kubectl get secret ${app}-tls -n default|grep -v NAME|wc -l
#fi
