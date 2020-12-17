provider "aws" {
  region = var.region
  alias  = "region"
}

terraform {
  backend "s3" {}
}

// Configure remote state on s3
data "terraform_remote_state" "infrastructure" {
  backend = "s3"

  config  = {
    region = var.region
    bucket = var.remote_state_bucket
    key    = var.remote_state_key
  }
}

// Create VPC
resource "aws_vpc" "kateri-vpc" {
  provider = aws.region
  cidr_block = var.vpc_cidr

  tags = {
    Name = "Kateri-VPC"
  }
}

// Create Internet Gateway
resource "aws_internet_gateway" "kateri-internet-gateway-for-vpc" {
  provider = aws.region
  vpc_id   = aws_vpc.kateri-vpc.id
}

// Get all Availability Zones in the current VPC "kateri-vpc"
data "aws_availability_zones" "availability-zones" {
  state    = "available"
}

// Create Private Subnet for EC2 Instance
resource "aws_subnet" "private-subnet-1" {
  provider          = aws.region
  availability_zone = element(data.aws_availability_zones.availability-zones.names, 0)
  vpc_id            = aws_vpc.kateri-vpc.id
  cidr_block        = var.private_subnet_1_cidr

  tags = {
    Name = "Private-Subnet-1"
  }
}

// Create Public Subnet for VPC
resource "aws_subnet" "public-subnet-1" {
  provider          = aws.region
  availability_zone = element(data.aws_availability_zones.availability-zones.names, 0)
  vpc_id            = aws_vpc.kateri-vpc.id
  cidr_block        = var.public_subnet_1_cidr

  tags = {
    Name = "Public-Subnet-1"
  }
}

// Create EC2 Instance w/ private subnet
resource "aws_instance" "kateri_ec2_instance" {
  ami = "ami-0a741b782c2c8632d" //Ubuntu 18
  instance_type = "t2.micro"
  key_name = "kateriec2key"
  subnet_id = aws_subnet.private-subnet-1.id
  //security_groups = [aws_security_group.kateri-ec2-sg.id]
}

// Create ELB
resource "aws_elb" "kateri-elb" {
  name = "kateri-sucks-at-this-elb"
  subnets = [aws_subnet.private-subnet-1.id]
  internal = true
  //security_groups = [aws_security_group.kateri-elb-sg.id]

  listener {
    instance_port = 8000
    instance_protocol = "http"
    lb_port = 80
    lb_protocol = "http"
  }

//  listener {
//    instance_port = 8000
//    instance_protocol = "http"
//    lb_port = 443
//    lb_protocol = "https"
    // ssl_certificate_id = "arn:aws:iam:123456789012:server-certificate/certName" // I don't totally understand this value
//  }

  health_check {
    healthy_threshold = 2
    interval = 30
    target = "HTTP:8000/"
    timeout = 3
    unhealthy_threshold = 2
  }

  instances = [aws_instance.kateri_ec2_instance.id]
}