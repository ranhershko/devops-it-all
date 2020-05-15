# TF-UPGRADE-TODO: Block type was not recognized, so this block and its contents were not automatically upgraded.
terraform {
  required_version = ">=0.12"
}

provider "helm" {
  version        = "~> 0.9"
  install_tiller = false
}

