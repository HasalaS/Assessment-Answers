resource "aws_lb" "main" {
  name               = "my-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = ["sg-845615452659"]
  subnets            = [aws_subnet.elb_public_1.id, aws_subnet.elb_public_2.id]
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.main.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      host        = "#{host}"
      path        = "/"
      port        = "443"
      protocol    = "HTTPS"
      query       = "#{query}"
      status_code = "HTTP_301"
    }
  }
}

resource "aws_lb_listener" "https" {
  load_balancer_arn = aws_lb.main.arn
  port              = 443
  protocol          = "HTTPS"
  certificate_arn   = "<YOUR_CERTIFICATE_ARN>"

  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.main.arn
  }
}

resource "aws_wafv2_web_acl" "main" {
  name        = "my-waf"
  scope       = "REGIONAL"
  default_action {
    allow {}
  }
  
  rule {
    name     = "AWSManagedRulesCommonRuleSet"
    priority = 1
    statement {
      managed_rule_group_statement {
        name    = "AWSManagedRulesCommonRuleSet"
        vendor  = "AWS"
      }
    }
    override_action {
      count {}
    }
    visibility_config {
      cloud_watch_metrics_enabled = true
      metric_name                 = "AWSManagedRulesCommonRuleSet"
      sampled_requests_enabled     = true
    }
  }

  rule {
    name     = "AWSManagedRulesAmazonIpReputationList"
    priority = 2
    statement {
      managed_rule_group_statement {
        name    = "AWSManagedRulesAmazonIpReputationList"
        vendor  = "AWS"
      }
    }
    override_action {
      count {}
    }
    visibility_config {
      cloud_watch_metrics_enabled = true
      metric_name                 = "AWSManagedRulesAmazonIpReputationList"
      sampled_requests_enabled     = true
    }
  }
}
