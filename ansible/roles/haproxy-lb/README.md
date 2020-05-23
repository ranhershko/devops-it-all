haproxy-lb role
===============

Haproxy installation ansible role with kubernetes management apps backend
1) Build haproxy AWS autoscale image using Hashicorp packer
2) Build haproxy AWS autoscale using ansible terraform module
3) Build management apps backend configuration
4) Create haproxy kubernetes eks readonly user

    WORK IN PROGRESS...

<img src="../../../images/haproxy.png" width="1200" >


Example Playbook use
--------------------
    - hosts: servers
      roles:
        - role: haproxy-lb

