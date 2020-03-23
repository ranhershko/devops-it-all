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

