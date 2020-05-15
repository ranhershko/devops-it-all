resource "helm_release" "filebeat" {
  name       = var.filebeat_helm_name
  chart      =  "${path.module}/../../../../helm/filebeat"
  namespace  = var.manage_namespace
  version    = "7.6.2"

  values = [
    "${file("${path.module}/override-values.yaml")}"
  ]

  #provisioner "local-exec" {
    #command = "helm test ${var.filebeat_helm_name}"
  #}
}
