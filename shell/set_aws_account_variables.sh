#!/bin/bash

export jenkins_default_vars=./roles/jenkins-env/defaults/main.yml

eksctl utils associate-iam-oidc-provider --cluster kubernetes-devops-it-all --approve || true
echo aws_account_id: \"$(aws sts get-caller-identity --query "Account" --output text)\" >> ${jenkins_default_vars}
echo oidc_provider: \"$(aws eks describe-cluster --name kubernetes-devops-it-all --query "cluster.identity.oidc.issuer" --output text | sed -e "s/^https:\/\///")\" >> ${jenkins_default_vars}
