variable "resource_group_name" {
  default     = "appDynamic"
}

variable "location" {
  default     = "westus"
}

variable "env" {
	default = "QA"
}

variable "delete_os_disk_on_termination" {
  default     = "false"
}

variable "data_sa_type" {
  default     = "Standard_LRS"
}

variable "data_disk_size_gb" {
  default     = "10"
}

variable "data_disk" {
  type        = "string"
  default     = "false"
}

variable "network_security_group_id" {}
variable "subnet_id" {}
variable "lb_nat_rule_ids" []
variable "lb_backend_address_pool_ids" []
variable "public_ip_address_id" {}

variable "vm_size" {
	default     = "Standard_DS1_V2"
}

variable "delete_os_disk_on_termination" {
  default     = "false"
}

variable "zones" {
  default     = "1"
}

variable "vm_os_publisher" {
  default     = ""
}

variable "vm_os_offer" {
  default     = ""
}

variable "vm_os_sku" {
  default     = ""
}

variable "vm_os_version" {
  default     = "latest"
}

variable "storage_account_type" {
  default     = "Premium_LRS"
}

variable "admin_username" {
  default     = "azureuser"
}

variable "ssh_key" {
  default     = "~/.ssh/id_rsa.pub"
}