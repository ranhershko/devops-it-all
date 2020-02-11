Ansible Role: kubectl
=========
[![Build Status](https://travis-ci.org/codecap/ansible-role-kubectl.svg?branch=master)](https://travis-ci.org/codecap/ansible-role-kubectl)
[![Ansible Galaxy](https://img.shields.io/badge/galaxy-codecap.kubectl-blue.svg)](https://galaxy.ansible.com/codecap/kubectl)

An ansible role to install kubectl (kubernetes ctl)

Requirements
------------

kubectl will be downloaded from the internet, so ensure you have internet access. *curl* is used for it.

Role Variables
--------------

```yaml
kubectl_conf:
  path:
    # path to place kubectl
    bin:    '~/bin'
    # path to place additional(completion) scripts
    script: '~/scripts'
  # version to download
  version:            latest
  # URL to get kubernetes latest release information
  latest_url:         'https://storage.googleapis.com/kubernetes-release/release/stable.txt'
  # URL to get kubernetes releases
  release_url:        'https://storage.googleapis.com/kubernetes-release/release'
  # whether to install completion scripts
  install_completion: true
```

Dependencies
------------

No

Example Playbook
----------------

The following playbook will install kubectl using default settings:
```yaml
    - hosts: servers
      roles:
         - role: codecap.kubectl
```

Please review defaults/main.yml for possible settings.

License
-------

BSD

Author Information
------------------

Vladislav Nazarenko  
http://codeberry.de
