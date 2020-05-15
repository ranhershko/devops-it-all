resource "helm_release" "kibana" {
  name       = var.kibana_helm_name
  chart      =  "${path.module}/../../../../helm/kibana"
  namespace  = var.manage_namespace
  version    = "7.6.2"

  values = [
    "${file("${path.module}/override-values.yaml")}"
  ]

  #provisioner "local-exec" {
    #command = "helm test ${var.kibana_helm_name}"
  #}
}
