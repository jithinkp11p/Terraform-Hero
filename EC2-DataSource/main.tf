resource "aws_instance" "devmachine" {
  ami           = data.aws_ami.linux_ami.id
  subnet_id     = data.aws_subnet.shared.id
  instance_type = var.instance_type
  tags = var.tags
  
}

data "aws_vpc" "vpc_name" {
  filter {
    name   = "tag:Name"
    values = ["Default VPC"]
  }
}

data "aws_subnet" "shared" {
  filter {
    name   = "tag:Name"
    values = ["newsubnet"]
  }
  vpc_id = data.aws_vpc.vpc_name.id
}

data "aws_ami" "linux_ami" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
  filter {
    name = "virtualization-type"
    values = ["hvm"]
  }
  
}