# Variables with .tfvar File
1. You can have all your variable values in a file and submit that file with -var-file argument.
2. Inside the file will be each variable name label as key and value for that
3. If there is a file in the same directory as the configuration named terraform.tfvars or  terraform.tfvars.json terraform will use the values it finds in that file.

# Commands to run script
1. terraform init
2. terraform plan -var-file="variables.tfvars" -var-file="secrets.tfvars"
3. terraform apply -var-file="variables.tfvars" -var-file="secrets.tfvars" -auto-approve
