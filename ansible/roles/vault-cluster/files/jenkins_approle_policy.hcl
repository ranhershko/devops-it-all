path "auth/**" {
  capabilities = [ "create", "read", "list" ]
}

path "secret/*" {
  capabilities = [ "create", "read", "list" ]
}

path "sys/mounts/*" {
  capabilities = [ "create", "read", "list" ]
}

path "sys/auth" {
  capabilities = [ "create", "read", "list" ]
}
  
path "sys/auth/approle" {
  capabilities = [ "create", "read", "list" ]
}

path "sys/auth/approle/*" {
  capabilities = [ "create", "read", "list" ]
}

# Login with AppRole
path "auth/approle/*" {
  capabilities = [ "create", "read", "list" ]
}

path "sys/policies/acl/*" {
  capabilities = [ "create", "read", "list" ]
}

# Read jenkins secret data
path "kv/data/jenkins-kubeconfig/*" {
  capabilities = [ "read", "read", "list" ]
}

path "kv/data/jenkins/*" {
  capabilities = [ "read", "read", "list" ]
}
