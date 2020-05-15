resource "helm_release" "jenkins" {
  name       = var.jenkins_helm_name
  chart      =  "${path.module}/../../../../helm/jenkins"
  namespace  = var.manage_namespace

  values = [
    "${file("${path.module}/override-values.yaml")}"
  ]

  #provisioner "local-exec" {
    #command = "helm test ${var.jenkins_helm_name}"
  #}
}
