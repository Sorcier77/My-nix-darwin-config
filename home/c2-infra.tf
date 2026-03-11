# --- DISPOSABLE CLOUD INFRASTRUCTURE (C2 + REDIRECTOR) ---

terraform {
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "~> 2.0"
    }
  }
}

variable "do_token" {
  description = "DigitalOcean API Token"
  type        = string
  sensitive   = true
}

# 1. SSH KEY FOR OPS
resource "digitalocean_ssh_key" "ops_key" {
  name       = "ops-mission-key"
  public_key = file("~/.ssh/id_rsa.pub")
}

# 2. C2 SERVER (SLIVER)
resource "digitalocean_droplet" "c2_server" {
  image    = "ubuntu-22-04-x64"
  name     = "mission-c2-backend"
  region   = "fra1" 
  size     = "s-1vcpu-2gb"
  ssh_keys = [digitalocean_ssh_key.ops_key.id]

  provisioner "remote-exec" {
    connection {
      type        = "ssh"
      user        = "root"
      private_key = file("~/.ssh/id_rsa")
      host        = self.ipv4_address
    }
    inline = [
      "apt-get update && apt-get install -y curl wget",
      "curl https://sliver.sh/install.sh | bash"
    ]
  }
}

# 3. REDIRECTOR (STEALTH)
resource "digitalocean_droplet" "redirector" {
  image    = "ubuntu-22-04-x64"
  name     = "cdn-frontend-static"
  region   = "nyc1" 
  size     = "s-1vcpu-1gb"
  ssh_keys = [digitalocean_ssh_key.ops_key.id]

  provisioner "remote-exec" {
    connection {
      type        = "ssh"
      user        = "root"
      private_key = file("~/.ssh/id_rsa")
      host        = self.ipv4_address
    }
    inline = [
      "apt-get update && apt-get install -y nginx",
      "echo 'server { listen 80; location / { proxy_pass http://${digitalocean_droplet.c2_server.ipv4_address}:8888; } }' > /etc/nginx/sites-available/default",
      "systemctl restart nginx"
    ]
  }
}

output "redirector_ip" {
  value = digitalocean_droplet.redirector.ipv4_address
}
