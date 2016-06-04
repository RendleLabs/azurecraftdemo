# Instructions to get credential tokens from the Azure Portal:
# https://www.terraform.io/docs/providers/azurerm/index.html

provider "azurerm" {
  subscription_id = ""
  client_id       = ""
  client_secret   = ""
  tenant_id       = ""
}

resource "azurerm_resource_group" "demo" {
    name = "despondentbadgerrg"
    location = "northeurope"
}

resource "azurerm_virtual_network" "demo" {
    name = "despondentbadgervn"
    address_space = ["10.0.0.0/16"]
    location = "northeurope"
    resource_group_name = "${azurerm_resource_group.demo.name}"
}

resource "azurerm_subnet" "demo" {
    name = "despondentbadgersub"
    resource_group_name = "${azurerm_resource_group.demo.name}"
    virtual_network_name = "${azurerm_virtual_network.demo.name}"
    address_prefix = "10.0.2.0/24"
}

resource "azurerm_public_ip" "demo" {
    name = "despondentbadgerip"
    location = "North Europe"
    resource_group_name = "${azurerm_resource_group.demo.name}"
    domain_name_label = "despondentbadger"
    public_ip_address_allocation = "dynamic"
}

resource "azurerm_network_interface" "demo" {
    name = "despondentbadgerni"
    location = "northeurope"
    resource_group_name = "${azurerm_resource_group.demo.name}"

    ip_configuration {
        name = "democonfiguration1"
        subnet_id = "${azurerm_subnet.demo.id}"
        private_ip_address_allocation = "dynamic"
        public_ip_address_id = "${azurerm_public_ip.demo.id}"
    }
}

resource "azurerm_network_security_group" "demo" {
    name = "despondentbadgernsg"
    location = "West US"
    resource_group_name = "${azurerm_resource_group.demo.name}"
}

resource "azurerm_network_security_rule" "inbound" {
    name = "despondentbadgersrhttp"
    priority = 100
    direction = "Inbound"
    access = "Allow"
    protocol = "Tcp"
    source_port_range = "*"
    destination_port_range = "80"
    source_address_prefix = "*"
    destination_address_prefix = "*"
    resource_group_name = "${azurerm_resource_group.demo.name}"
    network_security_group_name = "${azurerm_network_security_group.demo.name}"
}

resource "azurerm_storage_account" "demo" {
    name = "despondentbadgersa"
    resource_group_name = "${azurerm_resource_group.demo.name}"
    location = "northeurope"
    account_type = "Standard_LRS"

    tags {
        environment = "production"
    }
}

resource "azurerm_storage_container" "demo" {
    name = "vhds"
    resource_group_name = "${azurerm_resource_group.demo.name}"
    storage_account_name = "${azurerm_storage_account.demo.name}"
    container_access_type = "private"
}

resource "azurerm_virtual_machine" "demo" {
    name = "despondentbadger"
    location = "northeurope"
    resource_group_name = "${azurerm_resource_group.demo.name}"
    network_interface_ids = ["${azurerm_network_interface.demo.id}"]
    vm_size = "Standard_A0"

    storage_image_reference {
        publisher = "Canonical"
        offer = "UbuntuServer"
        sku = "16.04.0-LTS"
        version = "latest"
    }

    storage_os_disk {
        name = "myosdisk1"
        vhd_uri = "${azurerm_storage_account.demo.primary_blob_endpoint}${azurerm_storage_container.demo.name}/myosdisk1.vhd"
        caching = "ReadWrite"
        create_option = "FromImage"
    }

    os_profile {
        computer_name = "despondentbadger"
        admin_username = "demoadmin"
        admin_password = "S3cr3tSqu1rr3l"
    }

    os_profile_linux_config {
        disable_password_authentication = false
    }

    tags {
        environment = "production"
    }

    provisioner "remote-exec" {
        connection {
            type = "ssh"
            user = "demoadmin"
            password = "S3cr3tSqu1rr3l"
            host = "${azurerm_public_ip.demo.fqdn}"
        }
        inline = [
            "sudo apt-get update",
            "curl -fsSL https://get.docker.com/ | sh",
            "sudo usermod -aG docker demoadmin"
        ]
    }
}
