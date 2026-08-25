# Terraform Task 2

This configuration demonstrates a reusable resource group module and an Azure Storage remote state backend.

## Layout

- `main.tf` uses `modules/resource-group` to create one resource group.
- `modules/resource-group/` contains the module inputs, resource, and outputs.
- `bootstrap/` creates the storage account and private blob container used for Terraform state.
- `backend.hcl.example` contains the backend settings used by the root configuration.

## One-time setup

The backend storage must exist before the main configuration can initialize its remote backend. Run these commands from this directory after authenticating with Azure:

```bash
az login
cd bootstrap
terraform init
terraform apply -var-file=terraform.tfvars
cd ..
terraform init -backend-config=backend.hcl.example
```

If Terraform asks whether to migrate existing local state, answer `yes`. For a new Task 1 configuration there may be no state to migrate.

The backend stores state in Azure Blob Storage, where the AzureRM backend also provides state locking through blob leases.

## Main configuration

```bash
terraform fmt -recursive
terraform validate
terraform plan -var-file=terraform.tfvars
terraform apply -var-file=terraform.tfvars
```

Copy `terraform.tfvars.example` to `terraform.tfvars` and `backend.hcl.example` to a local backend settings file if you need to change the defaults. Do not commit files containing credentials or environment-specific secrets.
