resource "aws_s3_bucket" "bucket-remote" {
  bucket = "update-statefile"
   
}

resource "aws_s3_bucket_versioning" "Uversion" {
  bucket = aws_s3_bucket.bucket-remote.id
  versioning_configuration {
    status = "Enabled"
  }
  
}

resource "aws_dynamodb_table" "dynamodb-terraform-state-lock" {
  name = "terraform-state-lock-dynamo"
  hash_key = "LockID"
  read_capacity = 20
  write_capacity = 20
 
  attribute {
    name = "LockID"
    type = "S"
  }
}