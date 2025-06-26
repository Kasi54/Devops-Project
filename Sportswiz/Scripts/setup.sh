# -----------------------------------------
# 1. setup.sh - Entry point to set up everything
# -----------------------------------------

#!/bin/bash
set -e

# Variables (update according to your environment)
REGION="us-east-1"
INSTANCE_TYPE="t2.micro"
KEY_NAME="devops-key"
SECURITY_GROUP="devops-sg"
BUCKET_NAME="devops-infra-logs-$(date +%s)"
TAG="DevOpsInfra"

# 1. Create Key Pair (for SSH)
echo "Creating key pair..."
aws ec2 create-key-pair --key-name $KEY_NAME --query 'KeyMaterial' --output text > $KEY_NAME.pem
chmod 400 $KEY_NAME.pem

# 2. Create Security Group
echo "Creating security group..."
SG_ID=$(aws ec2 create-security-group --group-name $SECURITY_GROUP --description "DevOps Infra SG" --query 'GroupId' --output text)

# Allow SSH and Redis
echo "Authorizing security group ingress..."
aws ec2 authorize-security-group-ingress --group-id $SG_ID --protocol tcp --port 22 --cidr 0.0.0.0/0
aws ec2 authorize-security-group-ingress --group-id $SG_ID --protocol tcp --port 6379 --cidr 0.0.0.0/0

# 3. Launch EC2 instance
echo "Launching EC2 instance..."
AMI_ID=$(aws ec2 describe-images --owners amazon --filters "Name=name,Values=amzn2-ami-hvm-2.0.*-x86_64-gp2" --query 'Images[*].[ImageId]' --output text | head -n 1)
INSTANCE_ID=$(aws ec2 run-instances --image-id $AMI_ID --count 1 --instance-type $INSTANCE_TYPE --key-name $KEY_NAME --security-group-ids $SG_ID --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=$TAG}]" --query 'Instances[0].InstanceId' --output text)

# 4. Wait until instance is running
echo "Waiting for EC2 to be in 'running' state..."
aws ec2 wait instance-running --instance-ids $INSTANCE_ID

# 5. Get public IP
PUBLIC_IP=$(aws ec2 describe-instances --instance-ids $INSTANCE_ID --query "Reservations[0].Instances[0].PublicIpAddress" --output text)
echo "Instance launched with IP: $PUBLIC_IP"

# 6. Create S3 bucket
echo "Creating S3 bucket..."
aws s3api create-bucket --bucket $BUCKET_NAME --region $REGION --create-bucket-configuration LocationConstraint=$REGION

# 7. Upload script to EC2
echo "Uploading provisioning script to EC2..."
sleep 10
scp -i $KEY_NAME.pem provision.sh ec2-user@$PUBLIC_IP:/home/ec2-user/

# 8. Run provisioning on EC2
echo "Provisioning EC2..."
ssh -i $KEY_NAME.pem ec2-user@$PUBLIC_IP "chmod +x provision.sh && ./provision.sh"

# 9. Done
echo "Setup complete. Access your EC2 at $PUBLIC_IP"
