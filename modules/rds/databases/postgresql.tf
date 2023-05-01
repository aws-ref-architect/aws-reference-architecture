resource "aws_kms_key" "database_key" {
  description = "KMS key for RDS database."
}

resource "security_group" "postgresql_rds" {
  name        = "private-to-database"
  description = "Allow inbound traffic from private instances only."

  ingress {
    description = "HTTP"
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = var.private_cidr
  }
}

resource "aws_db_instance" "rds_postgresql" {
  identifier                            = "${var.environment}-postgresql"
  name                                  = "${var.environment}-${var.postgresql_database_name}"
  instance_class                        = var.instance_class
  allocated_storage                     = var.min_allocated_storage
  max_allocated_storage                 = var.max_allocated_storage
  engine                                = "postgres"
  engine_version                        = var.postgresql_engine_version
  backup_retention_period               = 0
  delete_automated_backups              = false
  deletion_protection                   = true
  skip_final_snapshot                   = false
  publicly_accessible                   = false
  vpc_security_group_ids                = [aws_security_group.postgresql_rds.id]
  manage_master_user_password           = true
  master_user_secret_kms_key_id         = aws_kms_key.database_key.key_id
  db_name                               = "postgres"
  username                              = "postgres"
  storage_encrypted                     = "true"
  backup_window                         = "10:00-11:00"
  maintenance_window                    = "Mon:11:00-Mon:12:00"
  auto_minor_version_upgrade            = true
  allow_major_version_upgrade           = true
  apply_immediately                     = false
  multi_az                              = true
  availability_zone                     = "us-east-1a"
  enabled_cloudwatch_logs_exports       = ["postgresql", "upgrade"]
  monitoring_interval                   = 1
  performance_insights_enabled          = true
  performance_insights_retention_period = 7
  port                                  = 5432
}
