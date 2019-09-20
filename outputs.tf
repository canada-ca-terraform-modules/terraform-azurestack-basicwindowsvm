output "vm" {
  value = azurestack_virtual_machine.VM
}

output "pip" {
  value = azurestack_public_ip.VM-EXT-PubIP
}

output "nic" {
  value = azurestack_network_interface.NIC
}
