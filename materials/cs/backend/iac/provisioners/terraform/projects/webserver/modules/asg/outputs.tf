output "webserver_asg_name" {
  value       = aws_autoscaling_group.webserver.name
  description = "Name of the webserver autoscaling group"
}
