provider "azurerm" {
    features {}
}

//App virtual network
resource "azurerm_virtual_network" "application" {
    name = "app-vnet"
    location = "West Europe"
    resource_group_name = "rg-krisha-playground"
    address_space = ["10.0.0.0/16"]
}

//application subnet
resource "azurerm_subnet" "subnet1" {
    name = "app-snet"
    resource_group_name = azurerm_virtual_network.application.resource_group_name
    virtual_network_name = azurerm_virtual_network.application.name
    address_prefixes = ["10.0.1.0/24"]
}

//application getway subnet
resource "azurerm_subnet" "subnet2" {
    name = "agw-snet"
    resource_group_name = azurerm_virtual_network.application.resource_group_name
    virtual_network_name = azurerm_virtual_network.application.name
    address_prefixes = ["10.0.2.0/24"]
}

//DNS Zone
resource "azurerm_dns_zone" "example-public" {
  name                = "mydomain.com"
  resource_group_name = azurerm_virtual_network.application.resource_group_name
}

//Public IP address
resource "azurerm_public_ip" "example" {
  name                = "mypublicip"
  location            = "West Europe"
  resource_group_name = azurerm_virtual_network.application.resource_group_name
  ip_version = "IPv4"
  sku = "Standard"
  sku_tier = "Regional"
  allocation_method = "Static"
  domain_name_label   = "krishadns"
}

//DNS a record
resource "azurerm_dns_a_record" "example" { 
  name                = "record1"
  zone_name           = azurerm_dns_zone.example-public.name
  resource_group_name = azurerm_virtual_network.application.resource_group_name
  ttl                 = 1
  target_resource_id  = azurerm_public_ip.example.id
}

//public ip for VM
resource "azurerm_public_ip" "my_vm_public_ip" {
  name                = "myVmIP"
  location            = azurerm_virtual_network.application.location
  resource_group_name = azurerm_virtual_network.application.resource_group_name
  allocation_method   = "Dynamic"
}

//NSG for Virtual machine
resource "azurerm_network_security_group" "my_terraform_nsg" {
  name                = "myNetworkSecurityGroup"
  location            = azurerm_virtual_network.application.location
  resource_group_name = azurerm_virtual_network.application.resource_group_name

  security_rule {
    name                       = "SSH"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}


//network interface
resource "azurerm_network_interface" "myvm_network" {
  name                = "myvm-nic"
  location            = azurerm_virtual_network.application.location
  resource_group_name = azurerm_virtual_network.application.resource_group_name

  ip_configuration {
    name                          = "example-ipconfig"
    subnet_id                     = azurerm_subnet.subnet1.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.my_vm_public_ip.id
  }
}

//NSG association
resource "azurerm_network_interface_security_group_association" "example" {
  network_interface_id      = azurerm_network_interface.myvm_network.id
  network_security_group_id = azurerm_network_security_group.my_terraform_nsg.id
}

//Virtual Machine
resource "azurerm_linux_virtual_machine" "example_linux_vm" {
  name                = "my-vm"
  location            = azurerm_virtual_network.application.location
  resource_group_name = azurerm_virtual_network.application.resource_group_name
  size                = "Standard_B1ls"

  network_interface_ids = [
    azurerm_network_interface.myvm_network.id,
  ]

  admin_username = "adminuser"
  admin_password = "Krisha123"
  disable_password_authentication = false

  os_disk {
    name              = "example-os-disk"
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

//application gateway

resource "azurerm_application_gateway" "example_application_gateway"{
    name = "my_Agw"
    location = azurerm_virtual_network.application.location
    resource_group_name = azurerm_virtual_network.application.resource_group_name

    sku {
        name = "Standard_v2"
        tier = "Standard_v2"
        capacity = 2
    }
    gateway_ip_configuration {
    name      = "my-gateway-ip-configuration"
    subnet_id = azurerm_subnet.subnet2.id
  }

  frontend_port {
    name = "myFrontendPort"
    port = 80
  }

  frontend_ip_configuration {
    name                 = "myAGIPConfig"
    public_ip_address_id = azurerm_public_ip.example.id
  }

  backend_address_pool {
    name = "example-backend-pool"
  }

   backend_http_settings {
    name                  = "myHTTPsetting"
    cookie_based_affinity = "Disabled"
    port                  = 80
    protocol              = "Http"
    request_timeout       = 20
  }

  http_listener {
    name                           = "myListener"
    frontend_ip_configuration_name = "myAGIPConfig"
    frontend_port_name             = "myFrontendPort"
    protocol                       = "Http"
  }

  request_routing_rule {
    name                       = "myRoutingRule"
    rule_type                  = "Basic"
    http_listener_name         = "myListener"
    backend_address_pool_name  = "example-backend-pool"
    backend_http_settings_name = "myHTTPsetting"
    priority                   = 1
  }

}


resource "azurerm_network_interface_application_gateway_backend_address_pool_association" "example" {
  network_interface_id    = azurerm_network_interface.myvm_network.id
  ip_configuration_name   = "example-ipconfig"
  backend_address_pool_id = tolist(azurerm_application_gateway.example_application_gateway.backend_address_pool).0.id
}