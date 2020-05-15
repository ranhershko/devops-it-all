resource "aws_dynamodb_table" "prometheus-devopsitall-terraform" {
  name         = "devopsitall-helm-prometheus-terraform-remote-lock"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"
  attribute {
    name = "LockID"
    type = "S"
  }
}
