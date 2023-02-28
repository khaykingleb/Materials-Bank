output "site_url" {
  value       = "http://${module.load_balancer.dns_name}"
  description = "URL of the web site"
}
