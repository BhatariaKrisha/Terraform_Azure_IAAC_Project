# Variables with Environment Variables
1.  Terraform searches the environment of its own process for environment variables named TF_VAR_ followed by the name of a declared variable.

# To set the environment variable in windows use following command:
    Set-Item -Path env:TF_VAR_vm_publisher -Value “Canonical”
    Set-Item -Path env:TF_VAR_vm_offer -Value “UbuntuServer”
    Set-Item -Path env:TF_VAR_vm_sku -Value “18.04-LTS”
    
# Commands to run script
1. terraform init
2. terraform plan -var-file="variables.tfvars" -var-file="secrets.tfvars"
3. terraform apply -var-file="variables.tfvars" -var-file="secrets.tfvars" -auto-approve
