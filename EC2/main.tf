locals {
        formatted_environment_name = lower(var.Environment)
        formated_project_name      = lower(replace(var.project_name," ","-"))
        formatted_port_list        = split(",", var.all_port_list)
        sg_rules                   = [ for port in local.formatted_port_list : {
          name        = "port-${port}"
          protocol    = "tcp"
          port        = port
          description = "Allow port ${port} traffic"
        } ]
}

resource "aws_instance" "example" {
  # first type constraint - number 
  count         = var.Instance_count
  # second type constraint - string
  region        = var.Region
  # third type constraint - Boolean
  associate_public_ip_address = var.public_ip

  # Fifth type constraint - set
  availability_zone = element(tolist(var.allowed_region), 2)

  ami           = "resolve:ssm:/aws/service/ami-amazon-linux-latest/al2023-ami-kernel-default-x86_64"
  instance_type = "t3.micro"

  # sixth type constraint - map
  tags = var.tags
  # tags = merge(var.default_tags,var.environment_tags)
}

resource "aws_security_group" "allow_tls" {
  name        = "allow_tls"
  description = "Allow TLS inbound traffic and all outbound traffic"

  tags = {
    Name = "allow_tls"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_tls_ipv4" {
  security_group_id = aws_security_group.allow_tls.id
  cidr_ipv4         = var.cidr_block[0]
  from_port         = 443
  ip_protocol       = "tcp"
  to_port           = 443
}


resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4" {
  security_group_id = aws_security_group.allow_tls.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}

