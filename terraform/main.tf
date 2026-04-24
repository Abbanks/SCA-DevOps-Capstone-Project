resource "docker_network" "app_network" {
  name = "app_network"
  driver = "bridge"

  internal = true
}

resource "docker_container" "web" {
  name    = "web_node"
  image   = "ubuntu:22.04"
  command = ["sleep", "infinity"]
  restart = "unless-stopped"

  networks_advanced {
    name = docker_network.app_network.name
  }

  healthcheck {
    test     = ["CMD", "bash", "-c", "echo healthy"]
    interval = "30s"
    timeout  = "10s"
    retries  = 3
  }
}

resource "docker_container" "app" {
  name    = "app_node"
  image   = "ubuntu:22.04"
  command = ["sleep", "infinity"]
  restart = "unless-stopped"

  networks_advanced {
    name = docker_network.app_network.name
  }

  healthcheck {
    test     = ["CMD", "bash", "-c", "echo healthy"]
    interval = "30s"
    timeout  = "10s"
    retries  = 3
  }
}

resource "docker_container" "db" {
  name    = "db_node"
  image   = "ubuntu:22.04"
  command = ["sleep", "infinity"]
  restart = "unless-stopped"

  networks_advanced {
    name = docker_network.app_network.name
  }
  
  healthcheck {
    test     = ["CMD", "bash", "-c", "echo healthy"]
    interval = "30s"
    timeout  = "10s"
    retries  = 3
  }
}

