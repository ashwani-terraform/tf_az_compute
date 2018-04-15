resource "azurerm_managed_disk" "linux_vm" {
  name                 = "${var.env}_${var.hostname}_mng_disk"
  location             = "${var.location}"
  resource_group_name  = "${var.resource_group_name}"
  storage_account_type = "${var.storage_account_type}"
  create_option        = "Empty"
  disk_size_gb         = "${var.data_disk_size_gb}"

  tags {
    environment = "${var.env}"
  }
}

resource "azurerm_public_ip" "linux_vm" {
  name                          = "${var.env}_${var.hostname}_pub_ip"
  location                      = "${var.location}"
  resource_group_name           = "${var.resource_group_name}"
  public_ip_address_allocation  = "${var.public_ip_address_id}"

  tags {
    environment = "${var.env}"
  }
}

resource "azurerm_network_interface" "linux_vm" {
  name                      = "${var.env}_${var.hostname}_nic"
  location                  = "${var.location}"
  resource_group_name       = "${var.resource_group_name}"
  network_security_group_id = "${var.network_security_group_id}"

  ip_configuration {
    name                                    = "${var.env}_${var.hostname}_ip_nic"
    subnet_id                               = "${var.subnet_id}"
    private_ip_address_allocation           = "${var.public_ip_address_id}"
    public_ip_address_id                    = "${azurerm_public_ip.linux_vm.id}"
    load_balancer_backend_address_pools_ids = ${var.lb_backend_address_pool_ids}
    load_balancer_inbound_nat_rules_ids     = ${var.lb_nat_rule_ids}
  }
}

resource "azurerm_virtual_machine" "linux_vm" {
  name                     = "${var.env}_${var.hostname}"
  location             = "${var.location}"
  resource_group_name  = "${var.resource_group_name}"
  network_interface_ids             = ["${azurerm_network_interface.linux_vm.id}"]
  availability_set_id               = "${azurerm_availability_set.linux_vm.id}"
  zones                            = "${var.zones}"
  vm_size                           = "${var.vm_size}"
  delete_os_disk_on_termination     = true
  delete_data_disks_on_termination  = true

  storage_image_reference {
    publisher = "${var.vm_os_publisher}"
    offer     = "${var.vm_os_offer}"
    sku       = "${var.vm_os_sku}"
    version   = "${var.vm_os_version}"
  }

  storage_os_disk {
    name              = "${var.env}_${var.hostname}_osdisk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "${var.storage_account_type}"
  }

  # Optional data disks
  storage_data_disk {
    name              = "${var.env}_${var.hostname}_datadisk"
    managed_disk_type = "${var.data_sa_type}"
    create_option     = "Empty"
    lun               = 0
    disk_size_gb      = "${var.data_disk_size_gb}"
  }

  os_profile {
    computer_name  = "${var.hostname}"
    admin_username = "${var.admin_username}"
  }

  os_profile_linux_config {
    disable_password_authentication = true
    ssh_keys = [{
      path     = "/home/${var.admin_username}.ssh/authorized_keys"
      key_data = "${file("${var.ssh_key}")}"
    }]
  }

  tags {
    environment = "${var.env}"
    name        = "${var.hostname}"
  }
}