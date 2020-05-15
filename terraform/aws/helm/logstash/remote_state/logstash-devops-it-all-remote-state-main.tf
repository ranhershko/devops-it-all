resource "aws_dynamodb_table" "logstash-devopsitall-terraform" {
  name         = "devopsitall-helm-logstash-terraform-remote-lock"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"
  attribute {
    name = "LockID"
    type = "S"
  }
}
