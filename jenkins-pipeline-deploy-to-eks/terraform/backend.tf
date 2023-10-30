terraform {
  backend "s3" {
    bucket = "primuslearning-app"
    region = "ap-northeast-2"
    key = "eks/terraform.tfstate"
  }
}