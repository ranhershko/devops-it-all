terraform {
  required_version = ">= 0.12.0"
  backend "s3" {}
    #encrypt = true
    #bucket  = "devopsitall-terraform-remote-state"
    #key     = "management-helm/grafana-terraform.tfstate"
    #region  = "us-east-1"

    #dynamodb_table = "devopsitall-helm-grafana-terraform-remote-lock"
 #} 
}
