#!/bin/bash

app=$1

kubectl create secret generic "${app}-tls" -n management \
    --from-file="${app}.crt=${PWD}/../ssl_created/${app}.crt" \
    --from-file="${app}.key=${PWD}/../ssl_created/${app}.key"

#kubectl create secret generic vault-tls -n $(namespace) \
  #--from-file="${DIR}/ca.crt" \
  #--from-file="vault.crt=${DIR}/vault-combined.crt" \
  #--from-file="vault.key=${DIR}/vault.key"

#if [ "$app" == "vault" ]
#then
  #kubectl create secret generic "${app}-tls" -n "${app}" \
    #--from-file="${app}.crt=${PWD}/../ssl_created/${app}.crt" \
    #--from-file="${app}.key=${PWD}/../ssl_created/${app}.key"
#else
  #kubectl create secret generic "${app}-tls" -n default \
    #--from-file="${app}.crt=${PWD}/../ssl_created/${app}.crt" \
    #--from-file="${app}.key=${PWD}/../ssl_created/${app}.key"
#fi
