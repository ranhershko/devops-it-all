path "sys/mounts/*" {
  capabilities = [ "create", "read", "list" ]
}

path "auth/*" {
  capabilities = [ "create", "read", "list", "update" ]
}

# Login with AppRole
path "auth/approle/*" {
  capabilities = [ "create", "read", "list", "update" ]
}

path "sys/auth" {
  capabilities = [ "create", "read", "list", "update" ]
}

path "sys/auth/approle" {
  capabilities = [ "create", "read", "list", "update" ]
}

path "sys/auth/approle/*" {
  capabilities = [ "create", "read", "list", "update" ]
}

path "secret/jenkins/*" {
  capabilities = [ "create", "read", "list", "update" ]
}

# Read jenkins secret data
path "secret/jenkins-kubeconfig/*" {
  capabilities = [ "create", "read", "list", "update" ]
}

path "secret/data/jenkins/*" {
  capabilities = [ "create", "read", "list", "update" ]
}

# Read jenkins secret data
path "secret/data/jenkins-kubeconfig/*" {
  capabilities = [ "create", "read", "list", "update" ]
}
