terraform {
  required_version = ">= 0.12.0"
  backend "s3" {}
    #encrypt = true
    #bucket  = "devopsitall-terraform-remote-state"
    #key     = "ihaproxy-autoscale--terraform.tfstate"
    #region  = "us-east-1"
#
    #dynamodb_table = "devopsitall-haproxy-autoscale-terraform-remote-lock"
 #}
}

provider "aws" {
  version = ">= 2.28.1"
  shared_credentials_file = var.shared_credentials_file
  region                  = var.region
}

provider "kubernetes" {
  load_config_file      = "true"
  version               = "1.9"
}

provider "local" {
  version = "~> 1.2"
}

provider "null" {
  version = "~> 2.1"
}

provider "template" {
  version = "~> 2.1"
}

provider "http" {
  version = "~> 1.1"
}

provider "tls" {
   version = "~> 2.1"
}

