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

# kubernetes
variable addon_job_timeout { default = 120 }
variable addons_include { default = [] }
variable always_pull_images { default = true }
variable api_server_lb { default = [] }
variable cgroup_driver { default = "cgroupfs" }
variable cilium_allocate_bpf { default = false }
variable cilium_debug { default = true }
variable cilium_ipam { default = "kubernetes" }
variable cilium_monitor { default = "maximum" }
variable cilium_node_init { default = false }
variable cilium_node_init_restart_pods { default = true }
variable cilium_operator_prometheus_enabled { default = true }
variable cilium_operator_replicas { default = 2 }
variable cilium_prometheus_enabled { default = true }
variable cilium_psp_enabled { default = true }
variable cilium_require_ipv4_pod_cidr { default = true }
variable cilium_service_monitor_enabled { default = true }
variable cilium_tunnel { default = "vxlan" }
variable cilium_wait_bfp { default = true }
variable cluster_cidr { default = "10.42.0.0/16" }
variable cluster_domain { default = "cluster.local" }
variable delete_local_data_on_drain { default = true }
variable dns_provider { default = "coredns" }
variable drain_grace_period { default = "-1" }
variable drain_on_upgrade { default = true }
variable drain_timeout { default = 60 }
variable enforce_node_allocatable { default = "pods,system-reserved,kube-reserved" }
variable etcd_backup_interval_hours { default = 8 }
variable etcd_backup_retention { default = 6 }
variable etcd_extra_args { default = {} }
variable etcd_extra_binds { default = [] }
variable etcd_extra_env { default = [] }
variable etcd_s3_access_key { default = "" }
variable etcd_s3_bucket_name { default = "" }
variable etcd_s3_endpoint { default = "" }
variable etcd_s3_folder { default = "" }
variable etcd_s3_region { default = "" }
variable etcd_s3_secret_key { default = "" }
variable eviction_hard { default = "memory.available<15%,nodefs.available<10%,nodefs.inodesFree<5%,imagefs.available<15%,imagefs.inodesFree<20%" }
variable fail_swap_on { default = true }
variable force_drain { default = true }
variable generate_serving_certificate { default = true }
variable hubble_enabled { default = true }
variable hubble_metrics { default = "{dns,drop,tcp,flow,port-distribution,icmp,http}" }
variable hubble_relay_enabled { default = true }
variable hubble_ui_enabled { default = true }
variable ignore_daemon_sets_on_drain { default = true }
variable ignore_docker_version { default = true }
variable ingress_provider { default = "none" }
variable kube_api_extra_args { default = {} }
variable kube_api_extra_binds { default = [] }
variable kube_api_extra_env { default = [] }
variable kube_controller_extra_args { default = {} }
variable kube_controller_extra_binds { default = [] }
variable kube_controller_extra_env { default = [] }
variable kube_reserved { default = "cpu=300m,memory=500Mi" }
variable kube_reserved_cgroup { default = "/podruntime.slice" }
variable kubelet_extra_args { default = {} }
variable kubelet_extra_binds { default = [] }
variable kubelet_extra_env { default = [] }
variable kubeproxy_extra_args { default = {} }
variable kubeproxy_extra_binds { default = [] }
variable kubeproxy_extra_env { default = [] }
variable kubernetes_version { default = "" }
variable max_pods { default = 32 }
variable monitoring { default = "metrics-server" }
variable node_cidr_mask_size { default = 26 }
variable node_monitor_grace_period { default = "15s" }
variable node_monitor_period { default = "2s" }
variable node_status_update_frequency { default = "4s" }
variable pod_eviction_timeout { default = "30s" }
variable pod_security_policy { default = false }
variable rke_authorization { default = "rbac" }
variable sans { default = [] }
variable scheduler_extra_args { default = {} }
variable scheduler_extra_binds { default = [] }
variable scheduler_extra_env { default = [] }
variable service_cluster_ip_range { default = "10.43.0.0/16" }
variable service_node_port_range { default = "30000-32767" }
variable system_reserved { default = "cpu=700m,memory=1Gi" }
variable system_reserved_cgroup { default = "/system.slice" }
variable upgrade_max_unavailable_controlplane { default = "1" }
variable upgrade_max_unavailable_worker { default = "10%" }
variable write_cluster_yaml { default = false }
variable write_kubeconfig { default = true }

# addons
variable addons { default = "cert-manager,descheduler,dex,externaldns,gangway,gatekeeper,ingress,klum,kured,metallb" }

# ingress
variable ingress_autoscale { default = true }
variable ingress_default_backend_enabled { default = true }
variable ingress_extra_args { default = {} }
variable ingress_max_replicas { default = 5 }
variable ingress_metrics_enabled { default = false }
variable ingress_min_replicas { default = 1 }
variable ingress_prometheus_rule_enabled { default = false }
variable ingress_service_monitor_enabled { default = false }
variable ingress_service_type { default = "LoadBalancer" }

# kured
variable kured_start_time { default = "00:00" }
variable kured_end_time { default = "23:59" }
variable kured_reboot_days { default = ["mon", "tu", "we", "th", "fr", "sat", "sun"] }

# descheduler LowNodeUtilization config
variable descheduler_low_node_utilization { default = true }
variable descheduler_rm_duplicates { default = true }
variable descheduler_rm_node_affinity_violation { default = true }
variable descheduler_rm_pods_affinity_violation { default = true }
variable descheduler_rm_taint_violation { default = true }

## treshold for watching nodes with high utilization
variable target_treshold_cpu { default = 50 }
variable target_treshold_mem { default = 75 }
variable target_treshold_pods { default = 75 }

## treshold for watching nodes with low utilization
variable treshold_cpu { default = 20 }
variable treshold_mem { default = 20 }
variable treshold_pods { default = 20 }

# auth-related vars
variable dex_expiry_device_requests { default = "5m" }
variable dex_expiry_id_tokens { default = "24h" }
variable dex_expiry_signing_keys { default = "6h" }
variable dex_ldap_bind_dn { default = "" }
variable dex_ldap_bind_pw { default = "" }
variable dex_ldap_endpoint { default = "" }
variable dex_ldap_groupsearch { default = true }
variable dex_ldap_groupsearch_basedn { default = "" }
variable dex_ldap_groupsearch_filter { default = "" }
variable dex_ldap_groupsearch_groupattr { default = "" }
variable dex_ldap_groupsearch_nameattr { default = "" }
variable dex_ldap_groupsearch_userattr { default = "" }
variable dex_ldap_insecure_no_ssl { default = true }
variable dex_ldap_ssl_skip_verify { default = true }
variable dex_ldap_start_tls { default = false }
variable dex_ldap_username_prompt { default = "" }
variable dex_ldap_usersearch { default = true }
variable dex_ldap_usersearch_basedn { default = "" }
variable dex_ldap_usersearch_emailattr { default = "" }
variable dex_ldap_usersearch_filter { default = "" }
variable dex_ldap_usersearch_idattr { default = "" }
variable dex_ldap_usersearch_nameattr { default = "" }
variable dex_ldap_usersearch_username { default = "" }
variable dex_oauth_skip_approval_screen { default = true }
variable dex_url { default = "" }
variable gangway_api_server_url { default = "" }
variable gangway_cluster_name { default = "" }
variable gangway_url { default = "" }
variable grafana_url { default = "" }

# externaldns vars
variable dns_zone { default = "" }
variable external_dns_access_key { default = "" }
variable external_dns_interval { default = "30s" }
variable external_dns_prefer_cname { default = false }
variable external_dns_region { default = "us-east-1" }
variable external_dns_secret_key { default = "" }
variable zone_id { default = "" }

# cert-manager
variable acme_email { default = "" }
variable acme_server { default = "production" }
variable cert_manager_access_key { default = "" }
variable cert_manager_aws_region { default = "us-east-1" }
variable cert_manager_secret_key { default = "" }

# metallb
variable metallb_addresses { default = "" }
