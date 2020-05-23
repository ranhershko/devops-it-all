kms-vault-unseal_key role
=========================

Create a AWS Key Management Services (KMS) for vault_unseal keys
1) Create AWS kms for vault unseak key
2) Update vault helm with AWS kms id

Example Playbook use
--------------------

    - hosts: servers
      roles:
         - role: kms-vault-unseal_key
