vpc-n-eks-remote-state role
===========================

Create devops-it-all terraform remote state S3 bucket
Create vpc-n-eks-remote-state terraform remote state dynamoDB lock table

Example Playbook use
--------------------
    - hosts: servers
      roles:
        - role: vpc-n-eks-remote-state

