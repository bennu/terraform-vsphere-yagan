locals {
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
  vsphere_cluster_id  = var.vsphere_cluster_id == "" ? module.vsphere.cluster_id : var.vsphere_cluster_id
}
