prometheus-env role
===================

prometheus helm chart installation ansible role using ansible terraform module

    WORK IN PROGRESS...

Requirements
------------

The prometheus helm install from local devops-it-all/helm/prometheus dir
Using: 
1) ansible terraform module
2) terraform helm provider

Example Playbook use
--------------------

    - hosts: servers
      roles:
        - role: prometheus-env

