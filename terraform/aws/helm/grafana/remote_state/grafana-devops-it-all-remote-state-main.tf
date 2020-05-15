resource "aws_dynamodb_table" "grafana-devopsitall-terraform" {
  name         = "devopsitall-helm-grafana-terraform-remote-lock"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"
  attribute {
    name = "LockID"
    type = "S"
  }
}
