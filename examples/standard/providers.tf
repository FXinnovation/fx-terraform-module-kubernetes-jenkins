provider "random" {
  version = "~> 2.0"
}

provider "kubernetes" {
  load_config_file = true
  version          = "~> 1.9"
}
