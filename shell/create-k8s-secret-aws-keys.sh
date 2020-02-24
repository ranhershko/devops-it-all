#! /bin/bash
kubectl create secret generic eks-creds -n vault --from-literal="AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID}" --from-literal="AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY}"
