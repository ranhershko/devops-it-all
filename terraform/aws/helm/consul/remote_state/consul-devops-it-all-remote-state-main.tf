resource "aws_dynamodb_table" "consul-devopsitall-terraform" {
  name         = "devopsitall-helm-consul-terraform-remote-lock"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"
  attribute {
    name = "LockID"
    type = "S"
  }
}
