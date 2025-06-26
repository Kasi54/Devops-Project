# -----------------------------------------
# 2. provision.sh - Provision services on EC2
# -----------------------------------------

#!/bin/bash
set -e

sudo yum update -y
sudo yum install -y redis

# Enable and start Redis
sudo systemctl enable redis
sudo systemctl start redis

# Install CloudWatch agent
echo "Installing CloudWatch Agent..."
sudo yum install -y amazon-cloudwatch-agent

cat <<EOF | sudo tee /opt/aws/amazon-cloudwatch-agent/bin/config.json
{
  "logs": {
    "logs_collected": {
      "files": {
        "collect_list": [
          {
            "file_path": "/var/log/messages",
            "log_group_name": "ec2-log-group",
            "log_stream_name": "{instance_id}-messages"
          }
        ]
      }
    }
  }
}
EOF

sudo /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl \
  -a fetch-config -m ec2 -c file:/opt/aws/amazon-cloudwatch-agent/bin/config.json -s

# Setup log rotation
cat <<EOF | sudo tee /etc/logrotate.d/redis
/var/log/redis/redis.log {
    daily
    rotate 7
    compress
    missingok
    notifempty
    create 0640 redis redis
}
EOF

echo "Provisioning complete."
