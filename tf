# Create 5 EBS volumes
resource "aws_ebs_volume" "data_volume_1" {
  availability_zone = aws_instance.postgres_server.availability_zone
  size              = 100
  type              = "gp3"
  encrypted         = true

  tags = {
    Name              = "${var.instance_name}-data-volume-1"
    Owner             = var.owner_name
    "Owner Contact"   = var.owner_contact
    "POC Name"        = var.poc_name
    Approver          = var.approver
    "Valid Till Date" = var.valid_till
  }
}

resource "aws_ebs_volume" "data_volume_2" {
  availability_zone = aws_instance.postgres_server.availability_zone
  size              = 100
  type              = "gp3"
  encrypted         = true

  tags = {
    Name              = "${var.instance_name}-data-volume-2"
    Owner             = var.owner_name
    "Owner Contact"   = var.owner_contact
    "POC Name"        = var.poc_name
    Approver          = var.approver
    "Valid Till Date" = var.valid_till
  }
}

resource "aws_ebs_volume" "data_volume_3" {
  availability_zone = aws_instance.postgres_server.availability_zone
  size              = 100
  type              = "gp3"
  encrypted         = true

  tags = {
    Name              = "${var.instance_name}-data-volume-3"
    Owner             = var.owner_name
    "Owner Contact"   = var.owner_contact
    "POC Name"        = var.poc_name
    Approver          = var.approver
    "Valid Till Date" = var.valid_till
  }
}

resource "aws_ebs_volume" "data_volume_4" {
  availability_zone = aws_instance.postgres_server.availability_zone
  size              = 100
  type              = "gp3"
  encrypted         = true

  tags = {
    Name              = "${var.instance_name}-data-volume-4"
    Owner             = var.owner_name
    "Owner Contact"   = var.owner_contact
    "POC Name"        = var.poc_name
    Approver          = var.approver
    "Valid Till Date" = var.valid_till
  }
}

resource "aws_ebs_volume" "data_volume_5" {
  availability_zone = aws_instance.postgres_server.availability_zone
  size              = 100
  type              = "gp3"
  encrypted         = true

  tags = {
    Name              = "${var.instance_name}-data-volume-5"
    Owner             = var.owner_name
    "Owner Contact"   = var.owner_contact
    "POC Name"        = var.poc_name
    Approver          = var.approver
    "Valid Till Date" = var.valid_till
  }
}

# Attach volumes to the EC2 instance
resource "aws_volume_attachment" "data_volume_1_attachment" {
  device_name = "/dev/sdf"
  volume_id   = aws_ebs_volume.data_volume_1.id
  instance_id = aws_instance.postgres_server.id
}

resource "aws_volume_attachment" "data_volume_2_attachment" {
  device_name = "/dev/sdg"
  volume_id   = aws_ebs_volume.data_volume_2.id
  instance_id = aws_instance.postgres_server.id
}

resource "aws_volume_attachment" "data_volume_3_attachment" {
  device_name = "/dev/sdh"
  volume_id   = aws_ebs_volume.data_volume_3.id
  instance_id = aws_instance.postgres_server.id
}

resource "aws_volume_attachment" "data_volume_4_attachment" {
  device_name = "/dev/sdi"
  volume_id   = aws_ebs_volume.data_volume_4.id
  instance_id = aws_instance.postgres_server.id
}

resource "aws_volume_attachment" "data_volume_5_attachment" {
  device_name = "/dev/sdj"
  volume_id   = aws_ebs_volume.data_volume_5.id
  instance_id = aws_instance.postgres_server.id
}
