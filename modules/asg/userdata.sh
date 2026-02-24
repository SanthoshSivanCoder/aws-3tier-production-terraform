#!/bin/bash
# Get the IP
TOKEN=$(curl -X PUT "http://169.254.169.254/latest/api/token" -H "X-aws-ec2-metadata-token-ttl-seconds: 21600")
PRIVATE_IP=$(curl -H "X-aws-ec2-metadata-token: $TOKEN" http://169.254.169.254/latest/meta-data/local-ipv4)

# Simple web server setup
yum install -y httpd
systemctl start httpd
systemctl enable httpd

echo "<h1>Hello from EC2</h1>" > /var/www/html/index.html
echo "<p>My Private IP is: $PRIVATE_IP</p>" >> /var/www/html/index.html