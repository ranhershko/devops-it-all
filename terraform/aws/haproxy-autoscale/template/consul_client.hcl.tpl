  - path: /home/centos/consul-client-data/client.hcl
    content: |
      advertise_addr = "{{ GetPrivateIP }}"
      client_addr =  "0.0.0.0"
      data_dir = "/home/${ remote_user }/consul-client-data"
      datacenter = "dc1"
      enable_syslog = true
      log_level = "DEBUG"
      retry_join = ["provider=k8s label_selector=\"app=consul,component=server\""]
