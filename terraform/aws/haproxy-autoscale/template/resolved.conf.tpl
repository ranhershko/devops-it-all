  - path: /etc/systemd/resolved.conf
    content: |
      [Resolve]
      DNS=127.0.0.1
      Domains=~consul
