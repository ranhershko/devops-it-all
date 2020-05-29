apiVersion: v1
data:
  mapRoles: |
    - rolearn: ${eks_worker_role_arn}
      username: system:node:{{EC2PrivateDNSName}}
      groups:
        - system:bootstrappers
        - system:nodes
    - rolearn: ${haproxy_role_arn}
      username: eks-readonly-user 
kind: ConfigMap
metadata:
  name: aws-auth
  namespace: kube-system
  selfLink: /api/v1/namespaces/kube-system/configmaps/aws-auth
