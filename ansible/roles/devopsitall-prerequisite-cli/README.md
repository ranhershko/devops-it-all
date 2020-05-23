devopsitall-prerequisite-cli role
=================================

Prepare management server:
1) Install needed cli\'s: terraform, packer, vault, helm, eksctl, aws_iam_authenticator, jq, aws
2) Create user home bin and update .bashrc

Example Playbook use
--------------------

    - hosts: localhost
      roles:
        - role: devopsitall-prerequisite-cli

