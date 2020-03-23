apiVersion: v1
metadata:
  name: aws-auth
  namespace: kube-system
kind: ConfigMap
data:
  mapRoles: |+
    - rolearn: arn:aws:iam::689166299232:role/kubernetes-devops-it-all20200321033326285700000008
      username: system:node:{{EC2PrivateDNSName}}
      groups:
        - system:bootstrappers
        - system:nodes
    - rolearn: ${readonly_eks_arn}
      username: eks-readonly-user

