##! /bin/bash -xv
#kubectl create secret generic vault-tls -n $(namespace) \
  #--from-file="${DIR}/ca.crt" \
  #--from-file="vault.crt=${DIR}/vault-combined.crt" \
  #--from-file="vault.key=${DIR}/vault.key"

kubectl create secret generic vault-tls -n default \
  --from-file="vault.crt=$1" \
  --from-file="vault.key=$2"
