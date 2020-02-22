resource "aws_s3_bucket" "devopsitall-terraform" {
  bucket = "devopsitall-terrform-remote-state"

  versioning {
    enabled = true
  }
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
}

resource "aws_dynamodb_table" "devopsitall-terraform" {
  name         = "devopsitall-vpc-n-eks-terrform-remote-lock"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"
  attribute {
    name = "LockID"
    type = "S"
  }
}
