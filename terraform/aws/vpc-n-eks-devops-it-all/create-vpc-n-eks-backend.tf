terraform {
  required_version = ">= 0.12.0"
  #backend "s3" {
    #encrypt = true
    #bucket  = "devopsitall-terrform-remote-state"
    #key     = "vpc-n-eks-terrform.tfstate"
    #region  = "us-east-1"
#
#    dynamodb_table = "devopsitall-vpc-n-eks-terrform-remote-lock"
#  }
}
