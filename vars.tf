# Resource naming

variable resource_naming { default = "" }

# vSphere data
# variable hosts { type = list(string) }
variable cluster {}
variable datacenter {}
variable datastore {}
variable dns_servers {}
variable gateway_address {}
variable network {}
variable resource_pool {}
variable search_domains {}
variable template {}
variable timezone { default = "UTC" }

# VMs
variable controlplane {}
variable etcd {}
variable latency_sensitivity { default = "normal" }
variable vm_folder { type = string }
variable vm_user { default = "ubuntu" }
variable worker_groups {
  default = [
    {
      name      = "small"
      cpus      = 2
      disk_size = 50
      memory    = 4096
      addresses = []
    },
    {
      name      = "medium"
      cpus      = 4
      disk_size = 100
      memory    = 8192
      addresses = []
    },
    {
      name      = "large"
      cpus      = 4
      disk_size = 100
      memory    = 16384
      addresses = []
    }
  ]
}
