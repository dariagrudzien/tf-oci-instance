output "route_table_id" {
  value = "${oci_core_route_table.default.id}"
}
output "security_list_id" {
  value = "${oci_core_security_list.default.id}"
}
output "subnet_id" {
  value = "${oci_core_subnet.default.id}"
}
output "vcn_id" {
  value = "${oci_core_vcn.default.id}"
}
output "dhcp_id" {
  value = "${oci_core_default_dhcp_options.default.id}"
}
output "igw_id" {
  value = "${oci_core_internet_gateway.default.id}"
}
output "instance_ip" {
  value = "${oci_core_instance.default.public_ip}"
}
