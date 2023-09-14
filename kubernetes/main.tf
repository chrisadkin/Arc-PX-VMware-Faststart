terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "= 2.0.2"
    }
    local = {
      source  = "hashicorp/local"
      version = "2.1.0"
    }
    null = {
      source  = "hashicorp/null"
      version = "3.1.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.1.0"
    }
    helm = {
      source  = "hashicorp/helm"
      # FIXME: Pinned version due to Helm provider bug in 2.0.0 & 2.0.1 regarding existing Terraform state
      # "Warning: Release does not exist"
      # See: https://github.com/hashicorp/terraform-provider-helm/issues/662
      version = "= 1.3.2"
    }
  }
}

provider "kubernetes" {
  config_path        = "~/.kube/config"
}

provider "helm" {
  kubernetes {
    config_path = "~/.kube/config"
  }
}

module "kubernetes_cluster" {
  source = "./modules/kubernetes_cluster"
  container_manager  = var.container_manager
  node_hosts         = var.node_hosts
  kubernetes_version = var.kubernetes_version
}

module "px_store" {
  source = "./modules/px_store"
}

module "metallb" {
  source = "./modules/metallb"
  helm_chart_version = var.helm_chart_version
  ip_pool_ranges     = var.ip_pool_ranges
}

module "px_backup" {
  source = "./modules/px_backup"
}
