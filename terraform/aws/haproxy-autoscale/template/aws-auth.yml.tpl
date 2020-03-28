apiVersion: v1
data:
  mapRoles: |+
    - rolearn: ${eks_worker_role_arn}
      username: system:node:{{EC2PrivateDNSName}}
      groups:
        - system:bootstrappers
        - system:nodes
    - rolearn: arn:aws:iam::689166299232:role/haproxy_ec2_role
      username: eks-readonly-user 
kind: ConfigMap
metadata:
  name: aws-auth
  namespace: kube-system
  selfLink: /api/v1/namespaces/kube-system/configmaps/aws-auth
