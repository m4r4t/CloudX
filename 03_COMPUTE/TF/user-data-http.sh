#!/bin/bash
echo "Hello, Terraform & AWS" > index.html
curl http://169.254.169.254/latest/meta-data/local-ipv4 >> index.html
nohup busybox httpd -f -p "${http_port}" &