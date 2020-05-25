jenkins-env role
================

jenkins helm chart installation ansible role using ansible terraform module

    WORK IN PROGRESS...

Requirements
------------

The Grafana helm installation is done from local devops-it-all/helm/jenkins dir
Using:
1) ansible terraform module
2) terraform helm provider

Example Playbook use
--------------------
    - hosts: servers
      roles:
        - role: jenkins-env
