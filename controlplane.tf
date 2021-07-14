resource "vsphere_virtual_machine" "controlplane" {
  depends_on = [
    null_resource.etcd_ready,
    # vsphere_virtual_machine.etcd,
  ]
  count               = local.controlplane_count
  datastore_id        = data.vsphere_datastore.datastore.id
  enable_disk_uuid    = true
  folder              = vsphere_folder.folder.path
  guest_id            = data.vsphere_virtual_machine.template.guest_id
  latency_sensitivity = var.latency_sensitivity
  memory              = lookup(var.controlplane, "memory")
  name                = format("%s-controlplane-%s", local.resource_naming, count.index + 1)
  nested_hv_enabled   = true
  num_cpus            = lookup(var.controlplane, "cpus")
  resource_pool_id    = data.vsphere_resource_pool.pool.id
  scsi_type           = data.vsphere_virtual_machine.template.scsi_type

# There is an unsolved issue with the provider regarding the disk configuration, so in the meantime we are not passing
# the value and letting terraform setting by default (true). More info in the next link:
# https://github.com/hashicorp/terraform-provider-vsphere/issues/1028
  disk {
    eagerly_scrub    = data.vsphere_virtual_machine.template.disks.0.eagerly_scrub
    label            = "disk0"
    size             = lookup(var.controlplane, "disk_size")
    #thin_provisioned = data.vsphere_virtual_machine.template.disks.0.thin_provisioned
  }

  network_interface {
    network_id = data.vsphere_network.network.id
  }

  clone {
    template_uuid = data.vsphere_virtual_machine.template.id
  }

  extra_config = {
    "guestinfo.userdata" = base64gzip(templatefile(format("%s/files/user-data", path.module), {
      authorized_key = tls_private_key.ssh.public_key_openssh
      hostname       = format("%s-controlplane-%s", local.resource_naming, count.index + 1)
      timezone       = var.timezone
      user           = var.vm_user
    }))
    "guestinfo.userdata.encoding" = "gzip+base64"
    "guestinfo.metadata" = base64gzip(
      yamlencode(
        {
          "instance-id"    = format("%s-controlplane-%s", local.resource_naming, count.index + 1)
          "local-hostname" = format("%s-controlplane-%s", local.resource_naming, count.index + 1)
          "network" = {
            "version" = 2
            "ethernets" = {
              "eth0" = {
                "link-local" = []
                "dhcp6"      = false
                "addresses"  = [element(lookup(var.controlplane, "addresses"), count.index)]
                "gateway4"   = var.gateway_address
                "nameservers" = {
                  "addresses" = var.dns_servers
                  "search"    = var.search_domains
                }
              }
            }
          }
        }
      )
    )
    "guestinfo.metadata.encoding" = "gzip+base64"
  }
}

resource "null_resource" "controlplane_ready" {
  # depends_on = [
  #   null_resource.etcd_ready,
  #   vsphere_virtual_machine.controlplane,
  #   vsphere_virtual_machine.etcd,
  # ]
  count = length(vsphere_virtual_machine.controlplane)

  triggers = {
    ip       = element(vsphere_virtual_machine.controlplane.*.default_ip_address, count.index)
    nodename = element(vsphere_virtual_machine.controlplane.*.name, count.index)
    labels   = jsonencode(lookup(var.controlplane, "labels", {}))
    taints   = jsonencode(lookup(var.controlplane, "taints", []))
    user     = var.vm_user
  }

  connection {
    type        = "ssh"
    host        = self.triggers.ip
    user        = self.triggers.user
    private_key = tls_private_key.ssh.private_key_pem
    timeout     = "10m"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo cloud-init status --wait > /dev/null",
      data.template_file.wait_for_dockerd.rendered,
    ]
  }
}
