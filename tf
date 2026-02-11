terraform {
  required_version = ">= 1.0"
  
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

# Use existing VPC
locals {
  vpc_id = "vpc-017cbb6b303f34e5e"
}

# Get a subnet from the VPC
data "aws_subnets" "vpc_subnets" {
  filter {
    name   = "vpc-id"
    values = [local.vpc_id]
  }
}

# Create security group for PostgreSQL
resource "aws_security_group" "postgres_sg" {
  name        = var.security_group_name
  description = "Security group for PostgreSQL server"
  vpc_id      = local.vpc_id

  # SSH access
  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.allowed_ssh_cidr
  }

  # PostgreSQL access
  ingress {
    description = "PostgreSQL"
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = var.allowed_postgres_cidr
  }

  # Allow all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name              = var.security_group_name
    Owner             = var.owner_name
    "Owner Contact"   = var.owner_contact
    "POC Name"        = var.poc_name
    Approver          = var.approver
    "Valid Till Date" = var.valid_till
  }
}

# Get the latest Amazon Linux 2023 AMI
data "aws_ami" "amazon_linux_2023" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-2023.*-x86_64"]
  }

  filter {
    name   = "state"
    values = ["available"]
  }
}

# User data script to install PostgreSQL
locals {
  user_data = <<-EOF
#!/bin/bash
set -e

# Log all output
exec > >(tee /var/log/user-data.log)
exec 2>&1

echo "Starting PostgreSQL installation..."

# Update system packages
dnf update -y

# Install PostgreSQL 15
dnf install -y postgresql15-server postgresql15-contrib

# Initialize PostgreSQL database
postgresql-setup --initdb

# Start and enable PostgreSQL service
systemctl start postgresql
systemctl enable postgresql

# Configure PostgreSQL to accept remote connections
sed -i "s/#listen_addresses = 'localhost'/listen_addresses = '*'/" /var/lib/pgsql/data/postgresql.conf

# Add rule to allow remote connections with password authentication
echo "host    all             all             0.0.0.0/0               md5" >> /var/lib/pgsql/data/pg_hba.conf

# Restart PostgreSQL to apply changes
systemctl restart postgresql

# Create default database and user
sudo -u postgres psql <<PSQL
CREATE USER ${var.postgres_user} WITH PASSWORD '${var.postgres_password}';
CREATE DATABASE ${var.postgres_db};
GRANT ALL PRIVILEGES ON DATABASE ${var.postgres_db} TO ${var.postgres_user};
PSQL

echo "PostgreSQL installation complete!"
echo "Database: ${var.postgres_db}"
echo "User: ${var.postgres_user}"
EOF
}

# Create EC2 instance
resource "aws_instance" "postgres_server" {
  ami           = data.aws_ami.amazon_linux_2023.id
  instance_type = var.instance_type
  key_name      = var.key_name
  subnet_id     = data.aws_subnets.vpc_subnets.ids[0]

  vpc_security_group_ids = [aws_security_group.postgres_sg.id]

  user_data = local.user_data

  root_block_device {
    volume_size = var.root_volume_size
    volume_type = "gp3"
  }

  tags = {
    Name              = var.instance_name
    Owner             = var.owner_name
    "Owner Contact"   = var.owner_contact
    "POC Name"        = var.poc_name
    Approver          = var.approver
    "Valid Till Date" = var.valid_till
  }
}

# Use existing Elastic IP
data "aws_eip" "existing" {
  public_ip = "67.202.41.96"
}

# Associate existing Elastic IP with instance
resource "aws_eip_association" "postgres_eip_assoc" {
  instance_id   = aws_instance.postgres_server.id
  allocation_id = data.aws_eip.existing.id
}


variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "us-east-1"
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.small"
}

variable "key_name" {
  description = "Name of the EC2 key pair to use for SSH access"
  type        = string
  default     = "att-postgres"
}

variable "instance_name" {
  description = "Name tag for the EC2 instance"
  type        = string
  default     = "postgres-server"
}

variable "security_group_name" {
  description = "Name for the security group"
  type        = string
  default     = "postgres-sg"
}

variable "allowed_ssh_cidr" {
  description = "CIDR blocks allowed to SSH into the instance"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "allowed_postgres_cidr" {
  description = "CIDR blocks allowed to connect to PostgreSQL"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "root_volume_size" {
  description = "Size of the root EBS volume in GB"
  type        = number
  default     = 20
}

variable "postgres_db" {
  description = "Name of the PostgreSQL database to create"
  type        = string
  default     = "myapp"
}

variable "postgres_user" {
  description = "PostgreSQL user to create"
  type        = string
  default     = "pgadmin"
}

variable "postgres_password" {
  description = "Password for the PostgreSQL user"
  type        = string
  sensitive   = true
  default     = "ChangeMe123!"
}

variable "owner_name" {
  description = "Owner name for resource tagging"
  type        = string
  default     = "Eunice"
}

variable "owner_contact" {
  description = "Owner phone or email for resource tagging"
  type        = string
  default     = "9486155305"
}

variable "poc_name" {
  description = "Point of contact name"
  type        = string
  default     = "att postgres"
}

variable "approver" {
  description = "Approver name"
  type        = string
  default     = "kiran"
}

variable "valid_till" {
  description = "Valid till date"
  type        = string
  default     = "24-01-2026"
}
