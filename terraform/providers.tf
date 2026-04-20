terraform {
  required_version = ">= 1.10.0"

  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 4.2.0"
    }
  }
}

provider "docker" {
  # Terraform will automatically find the default socket.
  # host = "unix:///var/run/docker.sock" 
}