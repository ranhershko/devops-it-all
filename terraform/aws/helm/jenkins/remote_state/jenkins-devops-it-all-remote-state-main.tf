resource "aws_dynamodb_table" "vault-devopsitall-terraform" {
  name         = "devopsitall-helm-jenkins-terraform-remote-lock"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"
  attribute {
    name = "LockID"
    type = "S"
  }
}
