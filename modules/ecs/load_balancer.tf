resource "aws_lb" "load_balancer" {
  name               = var.load_balancer_name
  internal           = false
  load_balancer_type = "application"
  security_groups    = []
  subnets            = var.subnet_ids

  enable_deletion_protection = true
  enable_cross_zone_load_balancing = true

  access_logs {
    bucket  = aws_s3_bucket.global_logs.id
    prefix  = "lb-${var.name}"
    enabled = true
  }
}

resource "aws_lb_target_group" "target_group" {
   name               = "target-group-${var.load_balancer_name}"
   target_type        = "instance"
   port               = 8080
   protocol           = "HTTP"
   vpc_id             = var.vpc_id

   health_check {
      healthy_threshold   = 2
      interval            = 30
      unhealthy_threshold = 2
      timeout             = 60
      path                = "/ping"
      port                = 8080
  }
}

resource "aws_lb_target_group_attachment" "tg_attachment_test" {
  target_group_arn = aws_lb_target_group.target_group.arn
  target_id        = aws_lb_target_group.target_group.id
  port             = 8080
}

resource "aws_lb_listener" "lb_listener_http" {
   load_balancer_arn    = aws_lb.load_balancer.arn
   port                 = "8080"
   protocol             = "HTTP"

   default_action {
    target_group_arn = aws_lb_target_group.target_group.arn
    type             = "forward"
  }
}
/*
resource "aws_lb_listener" "lb_listener_https" {
   load_balancer_arn    = aws_lb.load_balancer.arn
   port                 = "8080"
   protocol             = "HTTPS"

   default_action {
    target_group_arn = aws_lb_target_group.target_group.arn
    type             = "forward"
  }
}
*/