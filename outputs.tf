output "vm" {
  value = azurestack_virtual_machine.VM
}

output "pip" {
  value = var.public_ip ? azurestack_public_ip.VM-EXT-PubIP : "0.0.0.0"
}

output "nic" {
  value = azurestack_network_interface.NIC
}
