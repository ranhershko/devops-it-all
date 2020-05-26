vpc-n-eks role
===============

AWS VPC and EKS installation ansible role
1) Build AWS VPC and EKS - 3 availability zones
2) Update ${user_home}/.kube/config file
3) Update ${user_home}/.ssh/known_hosts
4) Create management apps namespace

    WORK IN PROGRESS...

Example Playbook use
--------------------
    - hosts: servers
      roles:
        - role: vpc-n-eks

