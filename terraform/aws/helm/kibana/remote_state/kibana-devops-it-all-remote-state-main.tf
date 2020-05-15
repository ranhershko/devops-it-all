resource "aws_dynamodb_table" "kibana-devopsitall-terraform" {
  name         = "devopsitall-helm-kibana-terraform-remote-lock"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"
  attribute {
    name = "LockID"
    type = "S"
  }
}
