resource "aws_kms_key" "database_key" {
  description = "KMS key for RDS database."
}

resource "aws_db_instance" "rds_postgresql" {
  identifier             = "${environment}-postgresql"
  name                   = "${environment}-postgresql"
  instance_class         = "db.t3.micro"
  allocated_storage      = 10
  max_allocated_storage = 100
  engine                 = "postgres"
  engine_version         = "15.2"
  backup_retention_period = 0
  delete_automated_backups = false
  deletion_protection = true
  skip_final_snapshot    = false
  publicly_accessible    = false
  vpc_security_group_ids = [aws_security_group.postgresql.id]
  manage_master_user_password = true
  master_user_secret_kms_key_id = aws_kms_key.database_key.key_id
  db_name = "postgres"
  username               = "postgres"
  storage_encrypted       = "true"
  backup_window = "10:00-11:00"
  maintenance_window = "Mon:11:00-Mon:12:00"
  auto_minor_version_upgrade = true
  allow_major_version_upgrade = true
  apply_immediately = false
  multi_az = true
  availability_zone = "us-east-1a"
  enabled_cloudwatch_logs_exports = ["postgresql", "upgrade"]
  monitoring_interval = 1
  performance_insights_enabled = true
  performance_insights_retention_period = 7
  port = 5432
}

resource "aws_db_instance" "rds_mysql" {
  identifier             = "${environment}-mysql"
  name                   = "${environment}-mysql"
  instance_class         = "db.t3.micro"
  allocated_storage      = 10
  max_allocated_storage = 100
  engine                 = "mysql"
  engine_version         = "8.0.32"
  backup_retention_period = 0
  delete_automated_backups = false
  deletion_protection = true
  skip_final_snapshot    = false
  publicly_accessible    = false
  vpc_security_group_ids = [aws_security_group.mysql.id]
  manage_master_user_password = true
  master_user_secret_kms_key_id = aws_kms_key.database_key.key_id
  db_name = "mysql"
  username               = "mysql"
  storage_encrypted       = "true"
  backup_window = "10:00-11:00"
  maintenance_window = "Mon:11:00-Mon:12:00"
  auto_minor_version_upgrade = true
  allow_major_version_upgrade = true
  apply_immediately = false
  multi_az = true
  availability_zone = "us-east-1a"
  enabled_cloudwatch_logs_exports = ["audit", "error", "general", "slowquery"]
  monitoring_interval = 1
  performance_insights_enabled = true
  performance_insights_retention_period = 7
  port = 3306
}

resource "aws_db_instance" "rds_mariadb" {
  identifier             = "${environment}-mariadb"
  name                   = "${environment}-mariadb"
  instance_class         = "db.t3.micro"
  allocated_storage      = 10
  max_allocated_storage = 100
  engine                 = "mariadb"
  engine_version         = "10.6"
  backup_retention_period = 0
  delete_automated_backups = false
  deletion_protection = true
  skip_final_snapshot    = false
  publicly_accessible    = false
  vpc_security_group_ids = [aws_security_group.mariadb.id]
  manage_master_user_password = true
  master_user_secret_kms_key_id = aws_kms_key.database_key.key_id
  db_name = "mariadb"
  username               = "mariadb"
  storage_encrypted       = "true"
  backup_window = "10:00-11:00"
  maintenance_window = "Mon:11:00-Mon:12:00"
  auto_minor_version_upgrade = true
  allow_major_version_upgrade = true
  apply_immediately = false
  multi_az = true
  availability_zone = "us-east-1a"
  enabled_cloudwatch_logs_exports = ["audit", "error", "general", "slowquery"]
  monitoring_interval = 1
  performance_insights_enabled = true
  performance_insights_retention_period = 7
  port = 3306
}
