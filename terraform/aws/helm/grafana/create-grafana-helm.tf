resource "helm_release" "grafana" {
  name      = var.grafana_helm_name
  chart     =  "${path.module}/../../../../helm/grafana"
  namespace = var.manage_namespace

  values = [
    "${file("${path.module}/override-values.yaml")}"
  ]

  #provisioner "local-exec" {
  #  command = "helm test ${var.grafana_helm_name}"
  #}
}
