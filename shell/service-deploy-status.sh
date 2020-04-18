#!/bin/bash

deployment_name=$1
count=0
while true
do
  sleep 5
  #if [ $(kubectl get deployment $deployment_name|grep -v NAME|tail -1|awk '{print $2}'|awk -F'\/' '{print $1 / $2}' 2&>1) != 1 ] ; then
    pod_count=`kubectl get pods |grep $deployment_name|awk '{print $2}'|awk -F'\/' '{print $1 / $2}' 2&>1) != 1 ] ; then
    echo "not ready"
    kubectl get deployment consul-devopsitall-consul-sync-catalog
    if $count == 10 ; then
      echo "Not ready after 5 min, time to leave"
      exit 99 
    fi
  else
    echo "The deployment is ready"
    exit 0
  fi
done
