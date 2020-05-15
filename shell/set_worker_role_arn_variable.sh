#!/bin/bash -xv

export haproxy_tfvars_file=../terraform/aws/haproxy-autoscale/terraform.tfvars
echo eks_worker_role_arn = \"$(kubectl -n kube-system get configmap aws-auth -o yaml|sed -n '/mapRoles/,/username: system:node/p' |awk 'NR>1 && NR<3'|awk '{print $3}')\" > ${haproxy_tfvars_file}
