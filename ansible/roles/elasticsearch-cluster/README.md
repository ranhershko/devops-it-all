elasticsearch-cluster role
==========================

Elasticsearch helm chart installation ansible role using ansible terraform module

    WORK IN PROGRESS...

Requirements
------------

The elasticsearch helm installation is done from local devops-it-all/helm/elasticsearch dir
Using: 
1) ansible terraform module
2) terraform helm provider

Example Playbook use
--------------------

    - hosts: servers
      roles:
        - role: elasticsearch-cluster

