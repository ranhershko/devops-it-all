  - path: /etc/systemd/system/consul.service
    content: |
      [Unit]
      Description=consul agent
      Requires=network-online.target
      After=network-online.target
      [Service]
      LimitNOFILE=65536
      Restart=on-failure
      ExecStart=/usr/bin/consul agent -config-dir /home/${ remote_user }/consul-client-data
      ExecReload=/bin/kill -HUP $MAINPID
      KillSignal=SIGINT
      Type=simple
      User=${ remote_user }
      Group=${ remote_group }
      [Install]
      WantedBy=multi-user.target
