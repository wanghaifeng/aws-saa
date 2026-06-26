# 1. Configure the AWS Provider pointing to Tokyo
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "ap-northeast-1" # Tokyo
}

# 2. Create a Custom VPC (Exam topic: Networking boundaries)
resource "aws_vpc" "saa_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true

  tags = {
    Name = "saa-practice-vpc"
  }
}

# 3. Create an Internet Gateway to allow traffic to the internet
resource "aws_internet_gateway" "saa_igw" {
  vpc_id = aws_vpc.saa_vpc.id

  tags = {
    Name = "saa-igw"
  }
}

# 4. Create a Public Subnet (Free tier EC2 will live here)
resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.saa_vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "ap-northeast-1a"
  map_public_ip_on_launch = true # Automatically assigns a public IP

  tags = {
    Name = "saa-public-subnet"
  }
}

# 5. Create a Route Table to route 0.0.0.0/0 traffic to the Internet Gateway
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.saa_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.saa_igw.id
  }

  tags = {
    Name = "saa-public-rt"
  }
}

# Associate the Subnet with the Route Table
resource "aws_route_table_association" "public_assoc" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_rt.id
}

# 6. Create a Security Group (Exam topic: Stateful Firewalls)
resource "aws_security_group" "saa_sg" {
  name        = "allow-ssh-http"
  description = "Allow inbound SSH and HTTP traffic"
  vpc_id      = aws_vpc.saa_vpc.id

  # Inbound SSH (For learning purposes, open to world, but restrict in production)
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Inbound HTTP
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Outbound traffic (Allow EC2 to download updates)
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "saa-security-group"
  }
}

# 7. Provision a Free-Tier Eligible EC2 Instance
resource "aws_instance" "web_server" {
  # Amazon Linux 2023 AMI ID for Tokyo (ap-northeast-1)
  ami           = "ami-0d52744d6551d851e"
  instance_type = "t3.small" # Strictly Free Tier eligible

  subnet_id              = aws_subnet.public_subnet.id
  vpc_security_group_ids = [aws_security_group.saa_sg.id]

  # A simple startup script to install Apache Web Server
  user_data = <<-EOF
              #!/bin/bash
              dnf update -y
              dnf install -y httpd
              systemctl start httpd
              systemctl enable httpd
              echo "<h1>Hello from AWS SAA Practice Lab via Terraform!</h1>" > /var/www/html/index.html
              EOF

  tags = {
    Name = "saa-free-tier-webserver"
  }
}

# 8. Output the public IP address so you can visit your web server
output "ec2_public_ip" {
  value       = aws_instance.web_server.public_ip
  description = "The public IP address of your web server instance."
}