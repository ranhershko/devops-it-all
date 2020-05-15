resource "helm_release" "prometheus" {
  name      = var.prometheus_helm_name
  chart     =  "${path.module}/../../../../helm/prometheus"
  namespace = var.manage_namespace

  values = [
    "${file("${path.module}/override-values.yaml")}"
  ]

  #provisioner "local-exec" {
  #  command = "helm test ${var.prometheus_helm_name}"
  #}
}
