#!/bin/bash
sudo apt update
sudo apt install -y awscli
sudo apt install -y nfs-common
echo "Hello, Terraform & AWS" > index.html
curl http://169.254.169.254/latest/meta-data/local-ipv4 >> index.html
nohup busybox httpd -f -p "${http_port}" &