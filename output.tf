output private_key { value = module.vsphere.private_key }
output nodes { value = module.vsphere.nodes }
# output controlplane { value = var.controlplane }

output api_server_url { value = module.kubernetes.api_server_url }
output client_cert { value = module.kubernetes.client_cert }
output client_key { value = module.kubernetes.client_key }
output cluster_ca_certificate { value = module.kubernetes.ca_crt }
output username { value = module.kubernetes.kube_admin_user }
