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
        taints    = w.taints
      }
      ]
    ]
  )

  nodes = {
    controlplane = flatten([
      for instance in null_resource.controlplane_ready : {
        ip     = instance.triggers.ip
        name   = instance.triggers.nodename
        labels = can(instance.triggers.labels) ? jsondecode(instance.triggers.labels) : {}
        taints = can(instance.triggers.taints) ? jsondecode(instance.triggers.taints) : []
      }
      ]
    )
    etcd = flatten([
      for instance in null_resource.etcd_ready : {
        ip     = instance.triggers.ip
        name   = instance.triggers.nodename
        labels = can(instance.triggers.labels) ? jsondecode(instance.triggers.labels) : {}
        taints = can(instance.triggers.taints) ? jsondecode(instance.triggers.taints) : []
      }
      ]
    )
    worker = flatten([
      for instance in null_resource.worker_ready : {
        ip     = instance.triggers.ip
        labels = can(instance.triggers.labels) ? jsondecode(instance.triggers.labels) : {}
        taints = can(instance.triggers.taints) ? jsondecode(instance.triggers.taints) : []
        name   = instance.triggers.nodename
      }
      ]
    )
  }

  enable_addons  = split(",", var.addons)
  enable_dex     = contains(local.enable_addons, "dex")
  enable_gangway = contains(local.enable_addons, "gangway")
  dex_url        = format("dex.%s", var.dns_zone)
  gangway_url    = format("gangway.%s", var.dns_zone)
  oidc_extra_args = {
    oidc-client-id      = "gangway"
    oidc-groups-claim   = "groups"
    oidc-issuer-url     = format("https://%s", local.dex_url)
    oidc-username-claim = "name"
  }

  kube_api_extra_args = local.enable_gangway ? merge(local.oidc_extra_args, var.kube_api_extra_args) : var.kube_api_extra_args
  cloud_provider      = var.enable_cloud_provider ? "vsphere" : "none"
  vsphere_cluster_id  = var.vsphere_cluster_id == "" ? data.vsphere_compute_cluster.cluster.id : var.vsphere_cluster_id
}
