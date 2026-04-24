variable "containers" {
  default = {
    web = {
      name = "web"
    }
    app = {
      name = "app"
    }
    db = {
      name = "db"
    }
  }
}