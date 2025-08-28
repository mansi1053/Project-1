#!/bin/bash
sudo apt update || sudo yum update -y
sudo apt install -y nginx || sudo yum install -y nginx
sudo systemctl enable nginx
sudo systemctl start nginx
echo "<h1>Deployed via Terraform</h1>" | sudo tee /var/www/html/index.html