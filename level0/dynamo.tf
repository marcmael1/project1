resource "aws_dynamodb_table" "dynamodb-terraform-state-lock" {
  name           = "remote-stateD"
  hash_key       = "LockID"
  read_capacity  = 10
  write_capacity = 10

  attribute {
    name = "LockID"
    type = "S"
  }
}
