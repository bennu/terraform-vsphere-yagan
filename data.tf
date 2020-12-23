# Resouce naming
resource random_string resource_naming {
  count   = var.resource_naming == "" ? 1 : 0
  length  = 14
  special = false
  upper   = false
}

# vSphere
data vsphere_datacenter datacenter { name = var.datacenter }

data vsphere_compute_cluster cluster {
  name          = var.cluster
  datacenter_id = data.vsphere_datacenter.datacenter.id
}

data vsphere_resource_pool pool {
  name          = var.resource_pool
  datacenter_id = data.vsphere_datacenter.datacenter.id
}

data vsphere_datastore datastore {
  name          = var.datastore
  datacenter_id = data.vsphere_datacenter.datacenter.id
}

data vsphere_network network {
  name          = var.network
  datacenter_id = data.vsphere_datacenter.datacenter.id
}

data vsphere_virtual_machine template {
  name          = var.template
  datacenter_id = data.vsphere_datacenter.datacenter.id
}

resource vsphere_folder folder {
  path          = var.vm_folder
  type          = "vm"
  datacenter_id = data.vsphere_datacenter.datacenter.id
}

# Cloud init

resource tls_private_key ssh {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# Node status
data template_file wait_for_dockerd {
  template = "while (! docker version 2>/dev/null); do sleep 5; done"
}
