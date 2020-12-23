# Yagan vSphere

This module aims to deploy infrastructure on vSphere.

## Requirements

| Name | Version |
|------|---------|
| terraform | `>= 0.13` |
| vsphere | `>= 1.15.0` |

## Providers

| Name | Version |
|------|---------|
| vsphere | `>= 1.15.0` |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| cluster | Cluster name on vSphere | `any` | n/a | yes |
| datacenter | Datacenter name on vSphere | `any` | n/a | yes |
| datastore | Datastore name on vSphere | `any` | n/a | yes |
| dns_servers | Network DNS servers for vms on vSphere | `any` | n/a | yes |
| gateway_address | Network Gateway for vms on vSphere | `any` | n/a | yes |
| network | Network name on vSphere | `any` | n/a | yes |
| resource_pool | Resource Pool name on vSphere | `any` | n/a | yes |
| search_domains | Network DNS searchs for vms on vSphere | `any` | n/a | yes |
| template | Image template to clone vms on vSphere | `any` | n/a | yes |
| vm_folder | The path to the folder to put this vms in, relative to the datacenter that the resource pool is in. | `string` | n/a | yes |
| controlplane | Map about nodes to used for building kubernetes controllers | `map` | <pre>{<br>  "addresses": [],<br>  "cpus": 4,<br>  "disk_size": 60,<br>  "memory": 4096,<br>  "taints": []<br>}</pre> | no |
| etcd | Map about nodes to used for building kubernetes etcd | `map` | <pre>{<br>  "addresses": [],<br>  "cpus": 2,<br>  "disk_size": 100,<br>  "memory": 8192,<br>  "taints": []<br>}</pre> | no |
| latency_sensitivity | Controls the scheduling delay of the vms. Use a higher sensitivity for applications that require lower latency. Can be one of low, normal, medium, or high. | `string` | `"normal"` | no |
| resource_naming | An arbitrary name can be prepend to resources. | `string` | `""` | no |
| timezone | Timezone for vms on vSphere | `string` | `"UTC"` | no |
| vm_user | Default username for vms on vSphere | `string` | `"ubuntu"` | no |
| worker_groups | Map about nodes to used for building kubernetes workers | `list` | <pre>[<br>  {<br>    "addresses": [<br>      "10.10.10.10/24"<br>    ],<br>    "cpus": 2,<br>    "disk_size": 50,<br>    "labels": {<br>      "node-workload": "small"<br>    },<br>    "memory": 4096,<br>    "name": "small",<br>    "taints": [<br>      {<br>        "effect": "NoSchedule",<br>        "key": "node.cloudprovider.kubernetes.io/uninitialized",<br>        "value": true<br>      }<br>    ]<br>  },<br>  {<br>    "addresses": [],<br>    "cpus": 4,<br>    "disk_size": 100,<br>    "labels": {<br>      "node-workload": "medium"<br>    },<br>    "memory": 8192,<br>    "name": "medium",<br>    "taints": []<br>  },<br>  {<br>    "addresses": [],<br>    "cpus": 4,<br>    "disk_size": 100,<br>    "labels": {<br>      "node-workload": "large"<br>    },<br>    "memory": 16384,<br>    "name": "large",<br>    "taints": []<br>  }<br>]</pre> | no |

## Outputs

| Name | Description |
|------|-------------|
| cluster_id | n/a |
| nodes | n/a |
| private_key | n/a |
| public_key | n/a |
