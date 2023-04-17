terraform {
  backend "s3" {
    bucket         = "do4m-ecs-tf"
    dynamodb_table = "do4m-ecs-tf-tbl"
    region         = "ap-southeast-1"
    key            = "LockID"
  }
}