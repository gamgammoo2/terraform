terraform {
  backend "s3" {
    bucket = "jeong-2259"
    region = "ap-northeast-2"
    key = "jenkins-server/terraform.tfstate"
  }
}