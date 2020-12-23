# Resource naming

variable resource_naming {
  description = "An arbitrary name can be prepend to resources."
  default     = ""
}

# vSphere data
variable cluster {
  description = "Cluster name on vSphere"
}
variable datacenter {
  description = "Datacenter name on vSphere"
}
variable datastore {
  description = "Datastore name on vSphere"
}
variable dns_servers {
  description = "Network DNS servers for vms on vSphere"
}
variable gateway_address {
  description = "Network Gateway for vms on vSphere"
}
variable network {
  description = "Network name on vSphere"
}
variable resource_pool {
  description = "Resource Pool name on vSphere"
}
variable search_domains {
  description = "Network DNS searchs for vms on vSphere"
}
variable template {
  description = "Image template to clone vms on vSphere"
}
variable timezone {
  description = "Timezone for vms on vSphere"
  default     = "UTC"
}

# VMs
variable controlplane {
  description = "Map about nodes to used for building kubernetes controllers"
  default = {
    addresses = []
    cpus      = 4
    disk_size = 60
    memory    = 4096
    taints    = []
  }
}
variable etcd {
  description = "Map about nodes to used for building kubernetes etcd"
  default = {
    addresses = []
    cpus      = 2
    disk_size = 100
    memory    = 8192
    taints    = []
  }
}
variable latency_sensitivity {
  description = "Controls the scheduling delay of the vms. Use a higher sensitivity for applications that require lower latency. Can be one of low, normal, medium, or high."
  default     = "normal"
}
variable vm_folder {
  description = "The path to the folder to put this vms in, relative to the datacenter that the resource pool is in."
  type        = string
}
variable vm_user {
  description = "Default username for vms on vSphere"
  default     = "ubuntu"
}
variable worker_groups {
  description = "Map about nodes to used for building kubernetes workers"
  default = [
    {
      addresses = ["10.10.10.10/24"]
      cpus      = 2
      disk_size = 50
      memory    = 4096
      name      = "small"
      labels    = { node-workload = "small" }
      taints = [{
        key    = "node.cloudprovider.kubernetes.io/uninitialized"
        value  = true
        effect = "NoSchedule"
      }]
    },
    {
      addresses = []
      cpus      = 4
      disk_size = 100
      memory    = 8192
      name      = "medium"
      labels    = { node-workload = "medium" }
      taints    = []
    },
    {
      addresses = []
      cpus      = 4
      disk_size = 100
      labels    = { node-workload = "large" }
      memory    = 16384
      name      = "large"
      taints    = []
    }
  ]
}