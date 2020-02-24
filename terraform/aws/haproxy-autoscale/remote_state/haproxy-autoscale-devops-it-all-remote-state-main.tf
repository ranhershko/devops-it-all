resource "aws_dynamodb_table" "devopsitall-terraform" {
  name         = "devopsitall-haproxy-autoscale-terrform-remote-lock"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"
  attribute {
    name = "LockID"
    type = "S"
  }
}
