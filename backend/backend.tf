terraform {
  backend "s3" {
    bucket         = "do4m-tf-main-bucket"
    dynamodb_table = "do4m-tf-main-tbl"
    key            = "LockID"
    region         = "ap-southeast-1"
  }
}