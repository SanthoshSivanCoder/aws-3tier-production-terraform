resource "aws_db_subnet_group" "rds_subnet_group" {
  name       = "${terraform.workspace}-rds-subnet-group"
  subnet_ids = var.private_subnet_ids

  tags = {
    Name = "${terraform.workspace}-rds-subnet-group"
  }
}

resource "aws_security_group" "rds_sg" {
  name        = "${terraform.workspace}-rds-sg"
  description = "Allow DB access from EC2"
  vpc_id      = var.vpc_id

  ingress {
    from_port       = var.db_port
    to_port         = var.db_port
    protocol        = "tcp"
    security_groups = [var.ec2_sg_id] # Only EC2 can access DB
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${terraform.workspace}-rds-sg"
  }
}


resource "aws_db_instance" "this" {
  identifier        = "${terraform.workspace}-db"
  engine            = "mysql"
  engine_version    = "8.0"
  instance_class    = var.instance_class
  allocated_storage = 20
  storage_type      = "gp2"

  db_name  = var.db_name
  username = var.db_username
  password = var.db_password

  db_subnet_group_name   = aws_db_subnet_group.rds_subnet_group.name
  vpc_security_group_ids = [aws_security_group.rds_sg.id]

  multi_az            = var.multi_az
  publicly_accessible = false

  backup_retention_period = 0
  skip_final_snapshot     = true

  tags = {
    Name = "${terraform.workspace}-rds"
  }
}
