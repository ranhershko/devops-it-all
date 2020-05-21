resource "helm_release" "consul" {
  name             = var.consul_helm_name
  chart            =  "${path.module}/../../../../helm/consul"
  namespace        = var.manage_namespace

  values = [
    "${file("${path.module}/override-values.yaml")}"
  ]

  #provisioner "local-exec" {
    #command = "helm test ${var.consul_helm_name}"
  #}
}
