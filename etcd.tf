resource "vsphere_virtual_machine" "etcd" {
  depends_on          = [vsphere_folder.folder, tls_private_key.ssh]
  count               = local.etcd_count
  datastore_id        = data.vsphere_datastore.datastore.id
  enable_disk_uuid    = true
  folder              = var.vm_folder
  guest_id            = data.vsphere_virtual_machine.template.guest_id
  latency_sensitivity = var.latency_sensitivity
  memory              = lookup(var.etcd, "memory")
  name                = format("%s-etcd-%s", local.resource_naming, count.index + 1)
  nested_hv_enabled   = true
  num_cpus            = lookup(var.etcd, "cpus")
  resource_pool_id    = data.vsphere_resource_pool.pool.id
  scsi_type           = data.vsphere_virtual_machine.template.scsi_type

  disk {
    eagerly_scrub    = data.vsphere_virtual_machine.template.disks.0.eagerly_scrub
    label            = "disk0"
    size             = lookup(var.etcd, "disk_size")
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
      hostname       = format("%s-etcd-%s", local.resource_naming, count.index + 1)
      timezone       = var.timezone
      user           = var.vm_user
    }))
    "guestinfo.userdata.encoding" = "gzip+base64"
    "guestinfo.metadata" = base64gzip(
      yamlencode(
        {
          "instance-id"    = format("%s-etcd-%s", local.resource_naming, count.index + 1)
          "local-hostname" = format("%s-etcd-%s", local.resource_naming, count.index + 1)
          "network" = {
            "version" = 2
            "ethernets" = {
              "eth0" = {
                "link-local" = []
                "dhcp6"      = false
                "addresses"  = [element(lookup(var.etcd, "addresses"), count.index)]
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

  lifecycle {
    ignore_changes = [
      disk
    ]
  }
}

resource "null_resource" "etcd_ready" {
  # depends_on = [vsphere_virtual_machine.etcd]
  count = length(vsphere_virtual_machine.etcd)

  triggers = {
    ip       = element(vsphere_virtual_machine.etcd.*.default_ip_address, count.index)
    nodename = element(vsphere_virtual_machine.etcd.*.name, count.index)
    labels   = jsonencode(lookup(var.etcd, "labels", {}))
    taints   = jsonencode(lookup(var.etcd, "taints", []))
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
