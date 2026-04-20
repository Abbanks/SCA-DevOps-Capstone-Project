output "container_ips" {
  value = {
    web = docker_container.web.network_data[0].ip_address
    app = docker_container.app.network_data[0].ip_address
    db  = docker_container.db.network_data[0].ip_address
  }
}