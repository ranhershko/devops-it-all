resource "helm_release" "logstash" {
  name       = var.logstash_helm_name
  chart      =  "${path.module}/../../../../helm/logstash"
  namespace  = var.manage_namespace

  values = [
    "${file("${path.module}/override-values.yaml")}"
  ]

  #provisioner "local-exec" {
    #command = "helm test ${var.logstash_helm_name}"
  #}
}
