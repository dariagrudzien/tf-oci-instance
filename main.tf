data "oci_identity_availability_domains" "ads" {
 compartment_id = "${var.compartment_ocid}"
}

# ==============
#  NETWORK
# ==============
resource "oci_core_vcn" "default" {
  cidr_block     = "${var.cidr}"
  dns_label      = "${var.vcn_dns_label}"
  compartment_id = "${var.compartment_ocid}"
  display_name   = "${var.vcn_name}"
}
resource "oci_core_default_dhcp_options" "default" {
  manage_default_resource_id = "${oci_core_vcn.default.default_dhcp_options_id}"
  display_name  = "${var.vcn_name}-default-dhcp-options"

  options {
    type  = "DomainNameServer"
    server_type = "VcnLocalPlusInternet"
  }
}
resource "oci_core_internet_gateway" "default" {

  compartment_id = "${var.compartment_ocid}"
  vcn_id = "${oci_core_vcn.default.id}"
  display_name = "${var.vcn_name}-gw"
  # why this lifecycle ?
  lifecycle {
    create_before_destroy = true
  }
}
# ==============
#  SUBNET
# ==============
resource "oci_core_route_table" "default" {

  compartment_id = "${var.compartment_ocid}"
  vcn_id = "${oci_core_vcn.default.id}"
  display_name = "${var.subnet_display_name}-rt"

  route_rules {
    destination = "0.0.0.0/0"
    network_entity_id = "${oci_core_internet_gateway.default.id}"
  }
}
resource "oci_core_security_list" "default" {

  compartment_id = "${var.compartment_ocid}"
  vcn_id = "${oci_core_vcn.default.id}"
  display_name = "${var.subnet_display_name}-sl"
  egress_security_rules {

    protocol = "all"
    destination = "0.0.0.0/0"
  }
  ingress_security_rules {
    # ssh
    tcp_options {
      max = 22
      min = 22
    }
    protocol = "6" # TCP
    source = "0.0.0.0/0"
  }
}
resource "oci_core_subnet" "default" {
    #Required
    cidr_block = "${var.cidr}"
    compartment_id = "${var.compartment_ocid}"
    vcn_id = "${oci_core_vcn.default.id}"

    #Optional
    display_name = "${var.subnet_display_name}"
    route_table_id = "${oci_core_route_table.default.id}"
    security_list_ids = ["${oci_core_security_list.default.id}"] #
}


# ==============
#  INSTANCE
# ==============
resource "oci_core_instance" "default" {
  #Required
  availability_domain = "${element(data.oci_identity_availability_domains.ads.availability_domains.*.name, 1)}"

  compartment_id      = "${var.compartment_ocid}"
  shape               = "${var.instance_shape}"

  create_vnic_details {
    #Required
    subnet_id = "${oci_core_subnet.default.id}"
    display_name = "${var.instance_create_vnic_details_display_name}"
  }

  display_name = "${var.instance_display_name}"
  metadata = {
    ssh_authorized_keys = "${chomp(file(var.ssh_public_key_path))}"
  }

  source_details {
    source_type             = "image"
    source_id               = "${var.instance-image}"
    boot_volume_size_in_gbs = "50"
  }

  preserve_boot_volume = false

  timeouts {
    create = "60m"
    delete = "2h"
  }
}


