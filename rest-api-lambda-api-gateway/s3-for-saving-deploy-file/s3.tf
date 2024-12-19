resource "aws_s3_bucket" "lambda_bucket" {
  bucket = "<bucket-name>" // TODO 폴더 병합 

  tags = {
    Name        = "<bucket-name>"
    Environment = "Dev"
  }

  force_destroy = true
}

resource "aws_s3_bucket_ownership_controls" "s3_bucket_ownership_controls" {
  bucket = aws_s3_bucket.lambda_bucket.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_public_access_block" "public_access_block" {
  bucket = aws_s3_bucket.lambda_bucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}
