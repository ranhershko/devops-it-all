#!/bin/bash

export haproxy_tfvars_file=../terraform/aws/haproxy-autoscale/terraform.tfvars
echo jenkins_svc_name = \"$(kubectl get svc --namespace=management|grep  jenkins|grep -v agent|awk '{print $1}')\" > ${haproxy_tfvars_file}
echo prometheus_server_svc_name = \"$(kubectl get svc --namespace=management|grep prometheus-server|awk '{print $1}')\" >> ${haproxy_tfvars_file}
echo grafana_svc_name = \"$(kubectl get svc --namespace=management|grep grafana|awk '{print $1}')\" >> ${haproxy_tfvars_file}
echo kibana_svc_name = \"$(kubectl get svc --namespace=management|awk '{print $1}'|grep kibana)\" >> ${haproxy_tfvars_file}
