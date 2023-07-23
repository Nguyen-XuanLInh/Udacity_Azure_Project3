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
    public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC9nHfnk6GjqlPf/99G7PnU8wPSMATAjZcVAQQpm5npiEP6VX7/1yUzjf27SUuyDg3rNmPfVuyn2qcQqof6bH2K3wraYZZNpeslcKfsBXhv5YaXy2KCc5MPz/qwfdHHlIrRPkw+dKdNYc4YubS8+O6z+zWGTgx5TjdT/TNkBwirmY3F3IXFE6i0Xm5OCfPCMApi8+aawgOQqTvIIs24Yhpc590fM16917V0FbCZFZd1uFpG68h+gY4S/yJS4cdd7FxNMDAlCoAU4apfi5jEOBAeH2cbxXaGl0oS/34B3vi7LS04hfCdaaOdQamxJmxCYDK9fm6BDjbvy20Lx0qi5r+EjwGsRiVh9DUz13pzLSPmRiM0JTPnebmbgwwYxO9tBgvf0NYTBHNAYxcl7w5k2ynprE3uIOeXkB0fNWOhjESLo4zobSifpY6qwxHMJw2/5LwEEFain8H6hze4ru16kKu/WiVQJW1lkaStFUXWrcee/HZ4LO8fvt0UKnxe8QNL+80="
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
