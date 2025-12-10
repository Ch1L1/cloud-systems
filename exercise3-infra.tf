terraform {
  required_providers {
    openstack = {
      source  = "terraform-provider-openstack/openstack"
      version = "~> 3.0.0"
    }
  }
}

# My resource for creating following resources:
# https://registry.terraform.io/providers/terraform-provider-openstack/openstack/latest/docs

provider "openstack" {}

resource "openstack_networking_secgroup_v2" "apache_sg" {
  name        = var.security_group
  description = "Allow HTTP"
}

resource "openstack_networking_secgroup_rule_v2" "allow_http" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 80
  port_range_max    = 80
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = openstack_networking_secgroup_v2.apache_sg.id
}

resource "openstack_compute_instance_v2" "apache_vm" {
  name            = var.vm_name
  image_name      = var.image_id
  flavor_name     = var.flavor_id
  key_pair        = var.key_pair
  security_groups = [openstack_networking_secgroup_v2.apache_sg.name]

  network {
    uuid = var.network_id
  }

  user_data = <<-EOF
    #!/bin/bash
    apt-get update -y
    apt-get install apache2 -y
    echo "Name: Tomas Homola, UCO: 567740" > /var/www/html/index.html
    systemctl restart apache2
  EOF
}

data "openstack_networking_floatingip_v2" "existing_fip" {
  address = "78.128.235.122"
}

resource "openstack_compute_floatingip_associate_v2" "fip_assoc" {
  floating_ip = data.openstack_networking_floatingip_v2.existing_fip.address
  instance_id = openstack_compute_instance_v2.apache_vm.id
}

output "vm-public-ip" {
  value = data.openstack_networking_floatingip_v2.existing_fip.address
}
