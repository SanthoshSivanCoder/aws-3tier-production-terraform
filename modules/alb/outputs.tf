output "alb_arn" {
  value = aws_lb.app.arn
}

output "app_tg_arn" {
  value = aws_lb_target_group.app_tg.arn
}