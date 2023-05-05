resource "aws_kms_key" "cluster" {
  description             = "ECS cluster logging key."
  deletion_window_in_days = 7
}

resource "aws_cloudwatch_log_group" "cluster" {
  name = "${var.environment}-ecs-cluster"
}

resource "aws_ecs_cluster_capacity_providers" "cluster" {
  cluster_name = aws_ecs_cluster.cluster.name

  capacity_providers = [aws_ecs_capacity_provider.cluster.name]

  default_capacity_provider_strategy {
    base              = 1
    weight            = 100
    capacity_provider = aws_ecs_capacity_provider.cluster.name
  }
}

resource "aws_ecs_capacity_provider" "cluster" {
  name = "cluster"

  auto_scaling_group_provider {
    auto_scaling_group_arn = aws_autoscaling_group.cluster.arn
  }
}

resource "aws_ecs_cluster" "cluster" {
  name = var.cluster_name

  lifecycle {
    create_before_destroy = true
  }

  configuration {
    execute_command_configuration {
      kms_key_id = aws_kms_key.cluster.arn
      logging    = "OVERRIDE"

      log_configuration {
        cloud_watch_encryption_enabled = true
        cloud_watch_log_group_name     = aws_cloudwatch_log_group.cluster.name
        s3_bucket_name                 = "global_logs"
        s3_bucket_encryption_enabled   = true
        s3_key_prefix                  = "ecs/"
      }
    }
  }

  setting {
    name  = "containerInsights"
    value = "enabled"
  }
}

resource "aws_cloudwatch_metric_alarm" "cpu_high" {
  alarm_name          = "${var.name}-cpureservation-high"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "CPUReservation"
  namespace           = "AWS/ECS"
  period              = "300"
  statistic           = "Maximum"
  threshold           = "80"

  dimensions {
    ClusterName = aws_ecs_cluster.cluster.name
  }

  alarm_description = "Scale up if the CPU reservation is above 80% for 5 minutes."
  alarm_actions     = ["${aws_autoscaling_policy.scale_up.arn}"]

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_cloudwatch_metric_alarm" "memory_high" {
  alarm_name          = "${var.name}-memoryreservation-high"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "MemoryReservation"
  namespace           = "AWS/ECS"
  period              = "300"
  statistic           = "Maximum"
  threshold           = "80"

  dimensions {
    ClusterName = aws_ecs_cluster.main.name
  }

  alarm_description = "Scale up if the memory reservation is above 80% for 5 minutes."
  alarm_actions     = ["${aws_autoscaling_policy.scale_up.arn}"]

  lifecycle {
    create_before_destroy = true
  }

  depends_on = ["aws_cloudwatch_metric_alarm.cpu_high"]
}

resource "aws_cloudwatch_metric_alarm" "cpu_low" {
  alarm_name          = "${var.name}-cpureservation-low"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "CPUReservation"
  namespace           = "AWS/ECS"
  period              = "300"
  statistic           = "Maximum"
  threshold           = "25"

  dimensions {
    ClusterName = aws_ecs_cluster.main.name
  }

  alarm_description = "Scale down if the CPU reservation is below 25% for 5 minutes."
  alarm_actions     = ["${aws_autoscaling_policy.scale_down.arn}"]

  lifecycle {
    create_before_destroy = true
  }
  depends_on = [aws_cloudwatch_metric_alarm.memory_high]
}

resource "aws_cloudwatch_metric_alarm" "memory_low" {
  alarm_name          = "${var.name}-memoryreservation-low"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "MemoryReservation"
  namespace           = "AWS/ECS"
  period              = "300"
  statistic           = "Maximum"
  threshold           = "25"

  dimensions {
    ClusterName = aws_ecs_cluster.main.name
  }

  alarm_description = "Scale down if the memory reservation is below 25% for 5 minutes."
  alarm_actions     = ["${aws_autoscaling_policy.scale_down.arn}"]

  lifecycle {
    create_before_destroy = true
  }

  depends_on = ["aws_cloudwatch_metric_alarm.cpu_low"]
}

resource "aws_autoscaling_group" "cluster" {
  name = var.cluster_name

  availability_zones   = ["${var.availability_zones}"]
  vpc_zone_identifier  = ["${var.subnet_ids}"]
  launch_configuration = aws_launch_configuration.main.id
  min_size             = var.min_cluster_size
  max_size             = var.max_cluster_size
  desired_capacity     = var.desired_cluster_size
  termination_policies = ["OldestLaunchConfiguration", "Default"]

  tag {
    key                 = "Name"
    value               = var.cluster_name
    propagate_at_launch = true
  }

  tag {
    key                 = "Cluster"
    value               = var.cluster_name
    propagate_at_launch = true
  }

  tag {
    key                 = "Environment"
    value               = var.environment
    propagate_at_launch = true
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_policy" "scale_up" {
  name                   = "${var.cluster_name}-scaleup"
  scaling_adjustment     = 2
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = aws_autoscaling_group.cluster.name

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_policy" "scale_down" {
  name                   = "${var.cluster_name}-scaledown"
  scaling_adjustment     = -1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = aws_autoscaling_group.cluster.name

  lifecycle {
    create_before_destroy = true
  }
}
