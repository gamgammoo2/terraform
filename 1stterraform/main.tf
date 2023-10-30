# basic framework
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "ap-northeast-2"
}
#basic framework

#테라폼은 두가지 명령어만 알면 댐~~
#resource : 리소스를 새로 생성할 때
#data : 기존 리소스를 가져올 때 or 가상으로 데이터를 정의할 때

#vpc는 기존에 만들어져있는걸 가져올거라 data 사용/ 만약 resource로 불러오면 vpc가 새로 생성됨
data "aws_vpc" "default" {
  filter {
    name   = "is-default"
    values = [true]
  }
}

#aws security_groups
resource "aws_security_group" "terraform" {
  name   = "terraform"
  vpc_id = data.aws_vpc.default.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "terraform"
  }
}


#        리소스타입 리소스이름
resource "aws_instance" "hello" {
  ami             = "ami-086cae3329a3f7d75"
  instance_type   = "t3.micro"
  key_name        = "terraform"
  security_groups = [aws_security_group.terraform.name]

  user_data = file("${path.module}/userdata.yaml")


  tags = {
    Name = "terraform"
  }
}


#테라폼 파일 읽어오는 함수 -> 구글검색 -> ex 긁어오기
