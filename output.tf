output private_key { value = tls_private_key.ssh.private_key_pem }
output public_key { value = tls_private_key.ssh.public_key_openssh }
output nodes { value = local.nodes }
output cluster_id { value = data.vsphere_compute_cluster.cluster.id }