# ===============
# SHARED
# ===============
variable "region" {
  description = "The region to target with this provider configuration."
}
variable "tenancy_ocid" {
  description = "The global identifier for your account, always shown on the bottom of the web console."
}
variable "user_ocid" {
  description = " The identifier of the user account you will be using for Terraform."
}
variable "fingerprint" {
  description = "The fingerprint of the public key."
}
variable "ssh_public_key_path" {}
variable "private_key_path" {
  description = "The path to the private key stored on your computer."
}
variable "instance_availability_domain" {}


# ===========
# instance
variable "instance_shape" {
  default = "VM.Standard1.2"
}
# variable "ssh_public_key" {}
variable "instance_display_name" {
  default = "daria-test1"
}
variable "instance_create_vnic_details_display_name" {
  default = "daria-test-vnic-1"
}

# TODO: this should be grabbed using data sources
variable "instance-image" {
  default = "ocid1.instance.oc1.phx.anyhqljsyzzw3xqcfnato66qxz62lom6hxvqmechjjc7yju4dkp2rgxo73ta"
}

# ===========
# subnet
variable "compartment_ocid" {}

variable "subnet_display_name" {
  default = "daria-subnet"
}

# ===========
# network
variable "cidr" {
  default = "10.0.0.0/16"
}
variable "vcn_dns_label" {
  default = "vcn1"
}
variable "vcn_name" {
  default = "daria-vcn"
}
variable "private_key_password" {
  description = "The pass phrase to the private key."
}
