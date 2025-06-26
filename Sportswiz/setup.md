# Step-by-Step Setup Guide

This guide walks you through setting up the entire infrastructure using the provided Bash scripts.

# ✅ Step 1: Prerequisites

Before you begin, ensure the following tools and permissions are in place:

🔧 Tools Required:
1. AWS CLI (configured with aws configure)

2. SSH client (ssh and scp)

3. Bash (run on Linux/macOS/WSL or Git Bash on Windows)

🔐 Permissions Required:
Your IAM user/role must have:

1. EC2 full access

2. S3 full access

3. IAM PassRole (for CloudWatch)

4. CloudWatch write permissions

# 📁 Step 2: Clone the Repository

git clone https://github.com/yourusername/devops-infra-project.git
cd devops-infra-project

# 🏗️ Step 3: Run the Setup Script

The setup.sh script will:

1. Create an EC2 key pair and security group

2. Launch an EC2 instance

3. Set up a new S3 bucket for backups

4. Copy provision.sh to the instance

5. Run remote provisioning (Redis, CloudWatch)

bash setup.sh

📌 Output: At the end, you’ll get the public IP of your EC2 instance. Save this for SSH access.

# 🔍 Step 4: Verify Components

🔁 Connect to the EC2 instance

ssh -i devops-key.pem ec2-user@<YOUR_PUBLIC_IP>

Check Redis is running

sudo systemctl status redis

You should see it active (running).

📊 Check CloudWatch logs

Go to CloudWatch Logs Console

1. Find log group: ec2-log-group

2. View log stream by instance ID

3. Confirm logs from /var/log/messages are appearing

📦 Check S3 backup

If you later run backup.sh, it will upload Redis logs:

bash backup.sh
Then check:

aws s3 ls s3://your-bucket-name/

# 🔁 Step 5: (Optional) Automate with Cron

To schedule regular Redis log backups:

crontab -e
Add:

0 * * * * /home/ec2-user/backup.sh >> /home/ec2-user/backup.log 2>&1
# 🧹 Cleanup (Optional)
To stop billing:


aws ec2 terminate-instances --instance-ids <instance-id>
aws ec2 delete-security-group --group-id <sg-id>
aws ec2 delete-key-pair --key-name devops-key
aws s3 rb s3://your-bucket-name --force