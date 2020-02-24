#!/bin/bash
vaultRootToken=$(kubectl logs vault-devopsitall-0 -n vault| sed -n -e 's/^Initial Root Token:[[:space:]]*\(.*\)/\1/p')
kubectl create secret generic vault-root-tokens -n vault --from-literal=root=${vaultRootToken} --save-config
