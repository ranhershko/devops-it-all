resource "aws_dynamodb_table" "filebeat-devopsitall-terraform" {
  name         = "devopsitall-helm-filebeat-terraform-remote-lock"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"
  attribute {
    name = "LockID"
    type = "S"
  }
}
