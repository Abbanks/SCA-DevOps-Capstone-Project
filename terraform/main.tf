resource "docker_network" "app_network" {
  name = "app_network"
}

resource "docker_container" "web" {
  name    = "web_node"
  image   = "ubuntu:22.04"
  command = ["sleep", "infinity"]
  restart = "always"
  networks_advanced {
    name = docker_network.app_network.name
  }
}

resource "docker_container" "app" {
  name    = "app_node"
  image   = "ubuntu:22.04"
  command = ["sleep", "infinity"]
  restart = "always"
  networks_advanced {
    name = docker_network.app_network.name
  }
}

resource "docker_container" "db" {
  name    = "db_node"
  image   = "ubuntu:22.04"
  command = ["sleep", "infinity"]
  restart = "always"
  networks_advanced {
    name = docker_network.app_network.name
  }
}