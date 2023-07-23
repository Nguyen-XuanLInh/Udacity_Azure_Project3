resource "azurerm_network_interface" "test" {
  name                = "${var.application_type}-${var.resource_type}-ni"
  location            = "${var.location}"
  resource_group_name = "${var.resource_group}"

  ip_configuration {
    name                          = "internal"
    subnet_id                     = "${var.subnet_id}"
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = "${var.public_ip}"
  }
}

resource "azurerm_linux_virtual_machine" "test" {
  name                = "${var.application_type}-${var.resource_type}-vm"
  location            = "${var.location}"
  resource_group_name = "${var.resource_group}"
  size                = "Standard_DS2_v2"
  admin_username      = "${var.admin_username}"
  admin_password      = "${var.admin_password}"
  disable_password_authentication = false
  network_interface_ids = [azurerm_network_interface.test.id]
  admin_ssh_key {
    username   = "${var.admin_username}"
    public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC29Nq2vLM/P5fKtZwSefig69whsuVBBR8ZhItT6d1h8YsZmY5ABkWDomBr1iQ2V7yNtyO0ZxFQipCy1ECiXKpeT222PX2VnMSf23x0UMkWo2pHSf1DmRTllRvckC6IS0En/XvWy6G+1RX82lFyLNanGXZPaYLLcGYMHdfFu1VzmYDcIMq6hqinaGxxrKuZPspzA1WnND9KGbU+AKOiMfRQprrBZJaNBf3Eir5bSCpwbTIUKfnD3Bwep19blb84D7A11onCmRAwUgbtksfmvAknnW7CEIAtMtb3PYPr3Fpm+8U7IR0HT1CzGjYNwVANZX3qDqhoP08Oe0zoT35hPHMaFTZs2AO8Ubu4g4Yq8q3ulJCPyvTx5efIa0irZlXHZ2QrCr8aF85fWIDtOhdlvtVcDsbaJQJieNXOKwm2jZEmAi+CVhv63LRfPwXKt/bKbbpeQliCDuHpiCRcQZClSumHqqmknLGFLgmbhD+bQrXMGsaaDQLRi1rxeCvXKFRObJM= devopsagent@phungLinuxVM"
  }
  os_disk {
    caching           = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }
}
