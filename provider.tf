provider kubernetes {
  client_certificate     = module.kubernetes.client_cert
  client_key             = module.kubernetes.client_key
  cluster_ca_certificate = module.kubernetes.ca_crt
  host                   = module.kubernetes.api_server_url
  load_config_file       = false
  username               = module.kubernetes.kube_admin_user
}

# Commented because it fails when planning with kubernetes-alpha provider
# https://github.com/hashicorp/terraform-provider-kubernetes-alpha/issues/34

# provider kubernetes-alpha {
#   client_certificate     = module.kubernetes.client_cert
#   client_key             = module.kubernetes.client_key
#   cluster_ca_certificate = module.kubernetes.ca_crt
#   host                   = module.kubernetes.api_server_url
#   server_side_planning   = false
#   username               = module.kubernetes.kube_admin_user
# }

provider helm {
  kubernetes {
    client_certificate     = module.kubernetes.client_cert
    client_key             = module.kubernetes.client_key
    cluster_ca_certificate = module.kubernetes.ca_crt
    host                   = module.kubernetes.api_server_url
    load_config_file       = false
    username               = module.kubernetes.kube_admin_user
  }
}
