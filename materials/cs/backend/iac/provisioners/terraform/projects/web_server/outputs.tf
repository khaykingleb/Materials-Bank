output "site_url" {
  value       = "http://${module.elastic_load_balancer.dns_name}"
  description = "Site URL"
}
