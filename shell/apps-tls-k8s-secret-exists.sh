#!/bin/bash -x
app=$1
if [ "$app" == "vault" ]
then
  kubectl get secret ${app}-tls -n ${app}|grep -v NAME|wc -l
else
  kubectl get secret ${app}-tls -n default|grep -v NAME|wc -l
fi
