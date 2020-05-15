resource "helm_release" "vault" {
  name       = var.vault_helm_name
  chart      =  "${path.module}/../../../../helm/vault"
  namespace  = var.manage_namespace
  # Support helm 2
  version    = "v0.4.0"
  #version    = "v0.3.3"

  values = [
    "${file("${path.module}/override-values.yaml")}"
  ]

  #provisioner "local-exec" {
    #command = "helm test ${var.vault_helm_name}"
  #}
}
