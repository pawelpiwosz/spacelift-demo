provider "aws" {
  region = "eu-central-1"
  assume_role_with_web_identity {
    role_arn                = "arn:aws:iam::616506319567:role/spacelift-role"
    session_name            = "mysession"
    web_identity_token_file = "/mnt/workspace/spacelift.oidc"
  }

  default_tags {
    tags = {
      Environment = "Sandbox"
      Terraform   = "True"
      Repo        = "spacelift-prep"
      Project     = "Spacelift tutorial"
    }
  }
}

resource "aws_s3_bucket" "mybucket" {
  bucket = "thisismytestbucketforspacelift"
}

resource "aws_s3_bucket" "mysecondbucket" {
  bucket = "thisismysecondtestbucketforspacelift"
}

data "aws_vpc" "default-vpc" {
  default = true
}

resource "aws_security_group" "my-sg" {
  name        = "test-sg"
  description = "test drifts"
  vpc_id      = data.aws_vpc.default-vpc.id

  ingress {
    description = "test entry"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["10.10.10.10/32"]
  }

  egress {
    description = "test entry"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

data "aws_ami" "ubuntu-recent" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

data "aws_subnet_ids" "list-of-subnets" {
  vpc_id = data.aws_vpc.default-vpc.id
}

locals {
  subnet_ids_list = tolist(data.aws_subnet_ids.list-of-subnets.ids)
}

resource "aws_network_interface" "ec2-eni" {
  subnet_id = local.subnet_ids_list[0]
}

resource "aws_instance" "drift-test" {
  ami           = data.aws_ami.ubuntu-recent
  instance_type = "t2.micro"

  network_interface {
    network_interface_id = aws_network_interface.ec2-eni.id
    device_index         = 0
  }

}