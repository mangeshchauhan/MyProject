resource "aws_security_group" "ec2" {
  name        = "ec2-security-group"
  description = "Security group for EC2 instances"
  vpc_id      = var.vpc_id

  tags = {
    Name        = "ec2-sg"
    Environment = var.environment
    Owner       = var.owner
    Project     = "Terraform-EC2"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_ssh_EC2" {
  security_group_id = aws_security_group.ec2.id
  from_port         = 22
  to_port           = 22
  ip_protocol       = "tcp"
  cidr_ipv4         = var.allowed_ssh_cidr
  description       = "Allow SSH from trusted IP"
}
resource "aws_vpc_security_group_ingress_rule" "allow_ssh_from_Office" {
  security_group_id = aws_security_group.ec2.id
  from_port         = 22
  to_port           = 22
  ip_protocol       = "tcp"
  cidr_ipv4         = var.allowed_ssh_cidr
  description       = "Allow SSH from trusted IP"
}


resource "aws_instance" "public" {
  ami                    = data.aws_ami.amazon_linux_2.id
  instance_type          = var.instance_type
  subnet_id              = var.public_subnet_id
  key_name              = var.key_name
  vpc_security_group_ids = [aws_security_group.ec2.id]

  tags = {
    Name = "public-instance"
  }
}

resource "aws_instance" "private" {
  ami                    = data.aws_ami.amazon_linux_2.id
  instance_type          = var.instance_type
  subnet_id              = var.private_subnet_id
  key_name              = var.key_name
  vpc_security_group_ids = [aws_security_group.ec2.id]

  tags = {
    Name = "private-instance"
  }
}

data "aws_ami" "amazon_linux_2" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}