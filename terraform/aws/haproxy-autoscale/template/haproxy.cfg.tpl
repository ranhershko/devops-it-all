  - path: /etc/haproxy/haproxy.cfg
    content: |
      #-----------------#
      #   haproxy.cfg   #
      #     global      #
      #-----------------#
      global
        log /dev/log  local0
        stats socket ${haproxy_socket} #mode 600 expose-fd listeners level user
        stats   timeout 30s
        pidfile /var/run/haproxy.pid
        maxconn ${haproxy_connection_num}
        chroot ${haproxy_chroot}
        user ${haproxy_user}
        group ${haproxy_group}
        daemon
        ca-base /etc/ssl/certs
        crt-base /etc/ssl/private
            
        ssl-default-bind-ciphers ECDHE-ECDSA-AES256-GCM-SHA384:ECDHE-RSA-AES256-GCM-SHA384:ECDHE-ECDSA-CHACHA20-POLY1305:ECDHE-RSA-CHACHA20-POLY1305:ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES128-GCM-SHA256:ECDHE-ECDSA-AES256-SHA384:ECDHE-RSA-AES256-SHA384:ECDHE-ECDSA-AES128-SHA256:ECDHE-RSA-AES128-SHA256
        ssl-default-bind-options ssl-min-ver TLSv1.2 no-tls-tickets
         
      #--------------------------------------------------------------------#
      # common defaults that all the 'listen' and 'backend' sections will  #
      # use if not designated in their block                               #
      #--------------------------------------------------------------------#
      defaults
        log                           global
        mode                          ${haproxy_frontend_mode}
        option                        httplog
        option                        dontlognull
        retries                       3
        timeout connect         10s
        timeout queue           1m
        timeout client          1m
        timeout server          1m
        timeout http-request    10s
        timeout http-keep-alive 10s
        timeout check           10s
         
      #---------------------------------------------------#
      #     main frontend which proxys to the backends    #
      #---------------------------------------------------#
      frontend haproxy_front
        bind            *:${haproxy_frontend_port}
        bind            *:443 ssl crt /etc/ssl/ca_bundle.crt
        mode            ${haproxy_frontend_mode}
        use_backend     backend_%[hdr(host),lower,map(/etc/haproxy/backends.map,default)]
        default_backend no-match
        redirect scheme https if !{ ssl_fc } # Redirect http requests to https

      #------------------#
      #     backend      #
      #------------------#
      backend backend_stats
        server local 127.0.0.1:8404
        mode ${haproxy_frontend_mode}
        stats  uri /
        stats  show-legends
        stats  refresh 10s
        acl manage_ip src ${management_server_ip}
        http-request deny if !manage_ip
          
      backend backend_consul
        balance roundrobin
        mode ${haproxy_frontend_mode}
        acl manage_ip src ${management_server_ip}
        http-request deny if !manage_ip
        server-template consului 3  _consul-devopsitall-consul-ui-management._tcp.service.consul resolvers consul resolve-prefer ipv4 check
        reqrep ^([^\ :]*)\ /(.*) \1\ /\2
        acl response-is-redirect res.hdr(Location) -m found
        rspirep ^Location:\ http://consului(1|2|3)/(.*) Location:\ http://consul.${domain_name}/\2 if response-is-redirect
             
      backend backend_vault
        balance roundrobin
        mode ${haproxy_frontend_mode}
        acl manage_ip src ${management_server_ip}
        http-request deny if !manage_ip
        server-template vaultui 3  _vault._tcp.service.consul resolvers consul resolve-prefer ipv4 check
          
      backend backend_jenkins
        balance roundrobin
        mode ${haproxy_frontend_mode}
        acl manage_ip src ${management_server_ip}
        acl github_whitelist src 192.30.252.0/22 185.199.108.0/22 140.82.112.0/20
        http-request deny if !manage_ip !github_whitelist
        server-template jenkinsui 1 _${jenkins_svc_name}-management._tcp.service.consul resolvers consul resolve-prefer ipv4 check
        http-request set-header X-Forwarded-Port %[dst_port]
        http-request add-header X-Forwarded-Proto https if { ssl_fc }
        reqrep ^([^\ :]*)\ /(.*)     \1\ /\2
        acl response-is-redirect res.hdr(Location) -m found
        rspirep ^Location:\ (http)://jenkinsui1/(.*) Location:\ https://jenkins.${domain_name}:443/\2  if response-is-redirect
           
      backend backend_prometheus
        balance roundrobin
        mode ${haproxy_frontend_mode}
        acl manage_ip src ${management_server_ip}
        http-request deny if !manage_ip
        balance roundrobin
        server-template prometheusui 1  _${prometheus_server_svc_name}-management._tcp.service.consul resolvers consul resolve-prefer ipv4 check
           
      backend backend_grafana
        balance roundrobin
        mode ${haproxy_frontend_mode}
        acl manage_ip src ${management_server_ip}
        http-request deny if !manage_ip
        server-template grafanaui 1  _${grafana_svc_name}-management._tcp.service.consul resolvers consul resolve-prefer ipv4 check
      
      backend backend_kibana
        balance roundrobin
        mode ${haproxy_frontend_mode}
        acl manage_ip src ${management_server_ip}
        http-request deny if !manage_ip
        server-template kibanaui 1  _${kibana_svc_name}-management._tcp.service.consul resolvers consul resolve-prefer ipv4 check

      backend backend_elasticsearch
        balance roundrobin
        mode ${haproxy_frontend_mode}
        acl manage_ip src ${management_server_ip}
        http-request deny if !manage_ip
        server-template elasticsearchui 1  _elasticsearch-master-management._tcp.service.consul resolvers consul resolve-prefer ipv4 check

      backend no-match
        http-request deny deny_status 400
         
      resolvers consul
        nameserver consul 127.0.0.1:8600
        accepted_payload_size   8192
        hold valid 5s 
