
data "aws_vpc" "default" {
  default = true
}

data "aws_ami" "amazon_linux_2" {
  most_recent = true
  owners       = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }

  filter {
    name   = "state"
    values = ["available"]
  }
}

resource "aws_security_group" "this" {
  name_prefix = "${var.name}-sg-"
  description = "Security group for EC2 instance"
  vpc_id      = var.vpc_id != "" ? var.vpc_id : data.aws_vpc.default.id

  ingress {
    description      = "SSH access"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = [var.allowed_ssh_cidr]
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge({
    Name = "${var.name}-sg"
  }, var.tags)
}

resource "aws_instance" "this" {
  count                       = var.instance_count
  ami                         = var.ami != "" ? var.ami : data.aws_ami.amazon_linux_2.id
  instance_type               = var.instance_type
  subnet_id                   = var.subnet_id != "" ? var.subnet_id : null
  vpc_security_group_ids      = [aws_security_group.this.id]
  key_name                    = var.key_name != "" ? var.key_name : null
  associate_public_ip_address = true

  tags = merge({
    Name = format("%s-%d", var.name, count.index + 1)
  }, var.tags)
}


