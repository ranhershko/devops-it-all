kind: ClusterRoleBinding
apiVersion: rbac.authorization.k8s.io/v1
metadata:
  name: eks-readonly-user-role-binding
  namespace: "*"
subjects:
- kind: User
  name: eks-readonly-user
  apiGroup: rbac.authorization.k8s.io
roleRef:
  kind: ClusterRole
  name: eks-readonly-user-role
  apiGroup: rbac.authorization.k8s.io
