locals {
  controlplane_count = length(var.controlplane.addresses)
  etcd_count         = length(var.etcd.addresses)
  resource_naming    = length(random_string.resource_naming) == 0 ? var.resource_naming : random_string.resource_naming.0.result
  worker_count       = length(flatten([var.worker_groups.*.addresses]))

  workers = flatten(
    [for w in var.worker_groups : [
      for i in range(length(w.addresses)) : {
        addresses = w.addresses
        cpus      = w.cpus
        disk_size = w.disk_size
        labels    = w.labels
        memory    = w.memory
        name      = w.name
      }
      ]
    ]
  )

  nodes = {
    controlplane = flatten([
      for instance in null_resource.controlplane_ready : {
        ip   = instance.triggers.ip
        name = instance.triggers.nodename
      }
      ]
    )
    etcd = flatten([
      for instance in null_resource.etcd_ready : {
        ip   = instance.triggers.ip
        name = instance.triggers.nodename
      }
      ]
    )
    worker = flatten([
      for instance in null_resource.worker_ready : {
        ip     = instance.triggers.ip
        labels = jsondecode(instance.triggers.labels)
        name   = instance.triggers.nodename
      }
      ]
    )
  }
}
