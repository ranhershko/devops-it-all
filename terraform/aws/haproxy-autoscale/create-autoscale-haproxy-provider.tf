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

