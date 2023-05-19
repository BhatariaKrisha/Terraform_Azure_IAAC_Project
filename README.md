# Variables with -var
1. You can give variable name with command line using -var 
2. use -var with terraform plan and apply command
3. For example: terraform plan -var "location=westeurope"

# Commands to run script
1. terraform init
2. terraform plan -var “app_vnet=app-vnet”  -var “hub_vnet=hub-vnet” -var “afw_pip=afwpip” -var-file="variables.tfvars" -var-file="secrets.tfvars"
3. terraform apply -var “app_vnet=app-vnet”  -var “hub_vnet=hub-vnet” -var “afw_pip=afwpip” -var-file="variables.tfvars" -var-file="secrets.tfvars" -auto-approve
