# 🔐 Security Overview

# ✅ IAM Policies

1. EC2 instance uses an IAM role with limited permissions:

   s3:PutObject for log backups.
   logs:PutLogEvents, logs:CreateLogStream for CloudWatch.

2. No hardcoded credentials used — relies on instance profile.

# ✅ VPC Isolation

1. Security group restricts traffic:

   Port 22: SSH access (open for initial testing only).
   Port 6379: Redis access (should be restricted to internal IPs).

2. Custom VPC can be used for better subnet control (currently using default VPC).

# ✅ Open Ports

1. Only essential ports opened:

   TCP 22 (SSH)
   TCP 6379 (Redis)

2. All other traffic is blocked by default.

# ✅ Backup & Encryption

1. Redis logs backed up to S3 with timestamping.

2. S3 encryption (AES-256) enabled by default if your account has encryption enforced.

3. Recommend enabling S3 versioning and bucket policies in production.

