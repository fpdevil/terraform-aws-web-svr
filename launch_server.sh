#!/bin/bash

echo "*** Installing apache2 ***"
sudo apt update
sudo apt -y install apache2

# fetch the token
export TOKEN=$(curl -X PUT "http://169.254.169.254/latest/api/token" -H "X-aws-ec2-metadata-token-ttl-seconds: 21600")
echo "TOKEN: ${TOKEN}" > /tmp/output.txt
echo "Executing curl -H "X-aws-ec2-metadata-token: ${TOKEN}" http://169.254.169.254/latest/meta-data/instance-id" >> /tmp/output.txt
curl -vH "X-aws-ec2-metadata-token: ${TOKEN}" http://169.254.169.254/latest/meta-data/instance-id >> /tmp/output.txt

# capture details
instance_id=$(curl -H "X-aws-ec2-metadata-token: ${TOKEN}" http://169.254.169.254/latest/meta-data/instance-id)
instance_az=$(curl -H "X-aws-ec2-metadata-token: ${TOKEN}" http://169.254.169.254/latest/meta-data/placement/availability-zone)
pub_hostname=$(curl -H "X-aws-ec2-metadata-token: ${TOKEN}" http://169.254.169.254/latest/meta-data/public-hostname)
pub_ip=$(curl -H "X-aws-ec2-metadata-token: ${TOKEN}" http://169.254.169.254/latest/meta-data/public-ipv4)
priv_hostname=$(curl -H "X-aws-ec2-metadata-token: ${TOKEN}" http://169.254.169.254/latest/meta-data/local-hostname)
priv_ip=$(curl -H "X-aws-ec2-metadata-token: ${TOKEN}" http://169.254.169.254/latest/meta-data/local-ipv4)

# create and write to HTML file
touch /var/www/html/index.html
cat > /var/www/html/index.html << EOF
<!DOCTYPE html>
<html>
  <head>
    <style>
      body {
      font-family:Verdana,sans-serif;
      background-color:#1E2939;
      display: grid;
      place-items: center;
      }
      h2 {
      color:#F3F2F1;
      }
      .outset {
      border-style: outset;
      }
      .key {
      color:#E1712B;
      }
      .value {
      color:#F8FAFC;
      }
    </style>
  </head>
  <body>
    <h2>AWS Infrastructure Details</h2>
    <table>
      <tr>
        <td class="key">EC2 InstanceID</td>
        <td class="value">${instance_id}</td>
      </tr>
      <tr>
        <td class="key">Availability Zone</td>
        <td class="value">${instance_az}</td>
      </tr>
      <tr>
        <td class="key">Public Hostname</td>
        <td class="value">${pub_hostname}</td>
      </tr>
      <tr>
        <td class="key">Public IP</td>
        <td class="value">${pub_ip}</td>
      </tr>
      <tr>
        <td class="key">Private Hostname</td>
        <td class="value">${priv_hostname}</td>
      </tr>
      <tr>
        <td class="key">Private IP</td>
        <td class="value">${priv_ip}</td>
      </tr>
    </table>
  </body>
</html>
EOF

sudo systemctl start apache2
sudo systemctl enable apache2

systemctl status apache2 --no-pager >> /tmp/output.txt
