output private_key { value = tls_private_key.ssh.private_key_pem }
output public_key { value = tls_private_key.ssh.public_key_openssh }
output nodes { value = local.nodes }
output cluster_id { value = data.vsphere_compute_cluster.cluster.id }

# output api_server_url { value = module.kubernetes.api_server_url }
# output client_cert { value = module.kubernetes.client_cert }
# output client_key { value = module.kubernetes.client_key }
# output cluster_ca_certificate { value = module.kubernetes.ca_crt }
# output username { value = module.kubernetes.kube_admin_user }
