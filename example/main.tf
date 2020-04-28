provider "vultr" {
  # In your .bashrc you need to set
  # export VULTR_API_KEY="Your Vultr API Key"
}

resource "vultr_server" "my_server" {
  plan_id = "${var.one_cpu_one_gb_ram}"
  region_id = "${var.vultr_seattle}"
  app_id = "${var.docker_centos}"
  os_id = "${var.os_type}"
  label = "terraform example"
  enable_ipv6 = true
  auto_backup = true
  enable_private_network = true
  notify_activate = false
  ddos_protection = true
  tag = "tag"
  firewall_group_id = "${vultr_firewall_group.fwg.id}"
}

resource "vultr_firewall_group" "fwg" {
  description = "docker-fwg"
}

resource "vultr_firewall_rule" "tcp" {
  firewall_group_id = "${vultr_firewall_group.fwg.id}"
  protocol = "udp"
  network = "${vultr_server.my_server.main_ip}/32"
  from_port = "8080"
}

resource "vultr_dns_domain" "my_domain" {
  domain = "tf-domain.com"
  server_ip = "${vultr_server.my_server.main_ip}"
}

resource "vultr_dns_record" "a-record" {
  data = "${vultr_server.my_server.main_ip}"
  domain = "${vultr_dns_domain.my_domain.id}"
  name = "www"
  type = "A"
  ttl = "3600"
}
