jenkins-env role
================

jenkins helm chart installation ansible role using ansible terraform module

    WORK IN PROGRESS...

<img src="../../../images/grafanaDashboard.PNG" width="1200" >


Requirements
------------

The Grafana helm install from local devops-it-all/helm/grafana dir
Using:
1) ansible terraform module
2) terraform helm provider

Example Playbook use
--------------------
    - hosts: servers
      roles:
         - role: grafana-env
