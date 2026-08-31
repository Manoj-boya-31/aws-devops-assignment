data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-*-x86_64"]
  }

  filter {
    name   = "state"
    values = ["available"]
  }
}

locals {
  staging_user_data = templatefile("${path.module}/user-data.sh.tftpl", {
    environment = "staging"
    db_host     = aws_db_instance.postgres.address
    db_name     = var.db_name
    db_user     = var.db_username
    db_password = var.db_password
  })

  production_user_data = templatefile("${path.module}/user-data.sh.tftpl", {
    environment = "production"
    db_host     = aws_db_instance.postgres.address
    db_name     = var.db_name
    db_user     = var.db_username
    db_password = var.db_password
  })
}

resource "aws_instance" "staging" {
  ami                         = data.aws_ami.amazon_linux.id
  instance_type               = var.instance_type
  subnet_id                   = aws_subnet.public[0].id
  vpc_security_group_ids      = [aws_security_group.app.id]
  associate_public_ip_address = true
  key_name                    = aws_key_pair.deployer.key_name
  iam_instance_profile        = aws_iam_instance_profile.ec2.name
  user_data                   = local.staging_user_data

  root_block_device {
    encrypted = true
  }

  tags = {
    Name        = "${var.project_name}-staging"
    Environment = "staging"
  }

  depends_on = [aws_db_instance.postgres]
}

resource "aws_instance" "production" {
  ami                         = data.aws_ami.amazon_linux.id
  instance_type               = var.instance_type
  subnet_id                   = aws_subnet.public[1].id
  vpc_security_group_ids      = [aws_security_group.app.id]
  associate_public_ip_address = true
  key_name                    = aws_key_pair.deployer.key_name
  iam_instance_profile        = aws_iam_instance_profile.ec2.name
  user_data                   = local.production_user_data

  root_block_device {
    encrypted = true
  }

  tags = {
    Name        = "${var.project_name}-production"
    Environment = "production"
  }

  depends_on = [aws_db_instance.postgres]
}

resource "aws_key_pair" "deployer" {
  key_name   = "${var.project_name}-deployer"
  public_key = var.ssh_public_key
}
