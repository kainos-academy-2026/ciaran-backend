variable "state_resource_group_name" {
  description = "Resource group containing Terraform state storage."
  type        = string
  default     = "rg-terraform-state"
}

variable "location" {
  description = "Azure region for Terraform state storage."
  type        = string
  default     = "ukwest"
}

variable "storage_account_name" {
  description = "Globally unique, lowercase storage account name."
  type        = string
  default     = "stterraformstateciaran"

  validation {
    condition     = can(regex("^[a-z0-9]{3,24}$", var.storage_account_name))
    error_message = "storage_account_name must be 3-24 lowercase letters or numbers."
  }
}

variable "container_name" {
  description = "Private blob container used for Terraform state."
  type        = string
  default     = "tfstate"
}
