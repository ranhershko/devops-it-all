  - path: /etc/dnsmasq.d/10-consul
    content: |
      # Enable forward lookup of the 'consul' domain:
      server=/consul/127.0.0.1#8600
