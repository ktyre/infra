// Create Security Group for EC2 instance
//resource "aws_security_group" "kateri-ec2-sg" {
//  name = "kateri-ec2-sg"
//  description = "SG for the ec2 instance"
//  vpc_id = data.terraform_remote_state.infrastructure.outputs.vpc_id
//
//  ingress {
//    from_port = 80
//    protocol = "http"
//    to_port = 80
//    cidr_blocks = []
//  }
//
//  egress {
//    from_port = 0
//    protocol = ""
//    to_port = 0
//    cidr_blocks = []
//  }
//
//  tags = {
//    Name = ""
//  }
//}
//
// Create Security Group for ELB
//resource "aws_security_group" "kateri-elb-sg" {
//  name = "kateri-elb-sg"
//  description = "SG for the ELB"
//  vpc_id = data.terraform_remote_state.infrastructure.outputs.vpc_id
//
//  ingress {
//    from_port = 0
//    protocol = ""
//    to_port = 0
//    cidr_blocks = []
//  }
//
//  egress {
//    from_port = 0
//    protocol = ""
//    to_port = 0
//    cidr_blocks = []
//  }
//
//  tags = {
//    Name = ""
//  }
//}
