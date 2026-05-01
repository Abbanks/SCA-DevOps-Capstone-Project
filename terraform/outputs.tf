output "container_ips" {
  value = {
    web        = try(docker_container.web.network_data[0].ip_address, "")
    app        = try(docker_container.app.network_data[0].ip_address, "")
    db         = try(docker_container.db.network_data[0].ip_address, "")
    monitoring = try(docker_container.monitoring.network_data[0].ip_address, "")
  }
}

output "web_host_port" {
  value       = var.web_host_port
  description = "Host port mapped to the web (nginx) container"
}

output "prometheus_url" {
  value       = "http://localhost:${var.prometheus_host_port}"
  description = "Prometheus UI URL"
}

output "grafana_url" {
  value       = "http://localhost:${var.grafana_host_port}"
  description = "Grafana UI URL (default login: admin / admin)"
}
