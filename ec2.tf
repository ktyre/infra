// Create EC2 Instance w/ private subnet
resource "aws_instance" "kateri_ec2_instance" {
  ami = "ami-0a741b782c2c8632d" //Ubuntu 18
  instance_type = "t2.micro"
  key_name = "kateriec2key"
  subnet_id = aws_subnet.private-subnet-1.id
  //security_groups = [aws_security_group.kateri-ec2-sg.id]
}

// Create ELB  --> REALLY STRUGGLING WITH LISTENER STUFF
resource "aws_elb" "kateri-elb" {
  name = "kateri-sucks-at-this-elb"
  subnets = [aws_subnet.public-subnet-1.id]
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