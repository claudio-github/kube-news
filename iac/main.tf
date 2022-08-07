terraform {
  required_providers {
    digitalocean = {
      source = "digitalocean/digitalocean"
      version = "2.21.0"
    }
  }
}

provider "digitalocean" {
  token = var.tkn
}


resource "digitalocean_kubernetes_cluster" "kube01" {
  name   = var.k8s_name
  region = var.region
  # Grab the latest version slug from `doctl kubernetes options versions`
  version = "1.21.14-do.1"

  node_pool {
    name       = "default"
    size       = "s-2vcpu-2gb"
    node_count = 2
  }
}

resource "digitalocean_kubernetes_node_pool" "kube01_nodepool" {
  cluster_id = digitalocean_kubernetes_cluster.kube01.id

  name       = "kube01-nodepool"
  size       = "s-2vcpu-2gb"
  node_count = 2
  
}



resource "local_file" "kube_config" {
    content  = digitalocean_kubernetes_cluster.kube01.kube_config.0.raw_config
    filename = var.kube_config_path
}

