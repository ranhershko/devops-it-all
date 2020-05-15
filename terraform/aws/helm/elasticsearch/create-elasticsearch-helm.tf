resource "helm_release" "elasticsearch" {
  name       = var.elasticsearch_helm_name
  chart      =  "${path.module}/../../../../helm/elasticsearch"
  namespace  = var.manage_namespace

  values = [
    "${file("${path.module}/override-values.yaml")}"
  ]

  #provisioner "local-exec" {
    #command = "helm test ${var.elasticsearch_helm_name}"
  #}
}
