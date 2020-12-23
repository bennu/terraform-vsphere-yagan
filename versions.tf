terraform {
  required_providers {
    vsphere = {
      source  = "hashicorp/vsphere"
      version = ">= 1.15.0"
    }
  }
  required_version = ">= 0.13"
}
