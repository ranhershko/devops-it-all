variable "consul_helm_name"  {
  description = "Consul helm name"
  default = "consul-devopsitall"
}

variable "vault_helm_name"  {
  description = "Vault helm name"
  default = "vault-devopsitall"
}

variable "prometheus_helm_name"  {
  description = "prometheus helm name"
  default = "prometheus-devopsitall"
}

variable "grafana_helm_name"  {
  description = "grafana helm name"
  default = "grafana-devopsitall"
}

variable "elasticsearch_helm_name"  {
  description = "Elasticsearch helm name"
  default = "elasticsearch-devopsitall"
}

variable "logstash_helm_name"  {
  description = "Logstash helm name"
  default = "logstash-devopsitall"
}

variable "filebeat_helm_name"  {
  description = "Filebeat helm name"
  default = "filebeat-devopsitall"
}

variable "kibana_helm_name"  {
  description = "Kibana helm name"
  default = "kibana-devopsitall"
}

variable "jenkins_helm_name"  {
  description = "Jenkins helm name"
  default = "jenkins-devopsitall"
}

variable "manage_namespace" {
  description = "management apps namespace"
  default = "management"
}
