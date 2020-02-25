#!/bin/bash -xv
#set -Eeuo pipefail

DIR="$1"

if [ -d ${DIR} ]; then
   mkdir -p "${DIR}"
fi

# Create the conf file
cat > "${DIR}/openssl.cnf" << EOF
[req]
default_bits = 2048
encrypt_key  = no
default_md   = sha256
prompt       = no
utf8         = yes
distinguished_name = req_distinguished_name
req_extensions     = v3_req
[req_distinguished_name]
C  = US
ST = Oregon
L  = Portland
O  = OSCON19
CN = jenkins
[v3_req]
basicConstraints     = CA:FALSE
subjectKeyIdentifier = hash
keyUsage             = digitalSignature, keyEncipherment
extendedKeyUsage     = clientAuth, serverAuth
subjectAltName       = @alt_names
[alt_names]
DNS.1 = "ec2-34-229-185-153.compute-1.amazonaws.com"
DNS.2 = "_jenkins-devopsitall._tcp.service.consul" 
EOF

# Generate Vault's certificates and a CSR
openssl genrsa -out "${DIR}/haproxy.key" 2048

openssl req \
  -new -key "${DIR}/haproxy.key" \
  -out "${DIR}/haproxy.csr" \
  -config "${DIR}/openssl.cnf"

# Create our CA
openssl req \
  -new \
  -newkey rsa:2048 \
  -days 120 \
  -nodes \
  -x509 \
  -subj "/C=US/ST=California/L=The Cloud/O=Vault CA" \
  -keyout "${DIR}/ca.key" \
  -out "${DIR}/ca.crt"

# Sign CSR with our CA
openssl x509 \
  -req \
  -days 120 \
  -in "${DIR}/haproxy.csr" \
  -CA "${DIR}/ca.crt" \
  -CAkey "${DIR}/ca.key" \
  -CAcreateserial \
  -extensions v3_req \
  -extfile "${DIR}/openssl.cnf" \
  -out "${DIR}/haproxy.crt"

# Combined crt and key for haproxy
cat "${DIR}/haproxy.key" "${DIR}/haproxy.crt" > "${DIR}/haproxy-keys.crt"

