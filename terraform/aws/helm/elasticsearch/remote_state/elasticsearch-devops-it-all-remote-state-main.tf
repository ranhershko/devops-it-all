resource "aws_dynamodb_table" "elasticsearch-devopsitall-terraform" {
  name         = "devopsitall-helm-elasticsearch-terraform-remote-lock"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"
  attribute {
    name = "LockID"
    type = "S"
  }
}
