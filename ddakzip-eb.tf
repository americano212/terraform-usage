resource "aws_s3_bucket" "default" {
  bucket = "ddakzip.applicationversion.bucket"
}

resource "aws_s3_object" "default" {
  bucket = aws_s3_bucket.default.id
  key    = "beanstalk/nodejs-v1.zip"
  source = "nodejs-v1.zip"
}

resource "aws_elastic_beanstalk_application" "default" {
  name        = "ddakzip-backend-eb"
  description = "ddakzip-backend-server"
}

resource "aws_elastic_beanstalk_application_version" "default" {
  name        = "tf-test-version-label"
  application = "tf-test-name"
  description = "application version created by terraform"
  bucket      = aws_s3_bucket.default.id
  key         = aws_s3_object.default.id
}