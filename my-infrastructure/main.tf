terraform {
  backend "azurerm" {}
}

module "resource_group" {
  source = "./modules/resource-group"

  name        = "${var.resource_group_name}-${var.environment}"
  location    = var.location
  environment = var.environment
}
