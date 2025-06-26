# Lightweight Internal Infrastructure

A high-availability, Bash-scripted DevOps infrastructure built on AWS with EC2, S3, Redis, CloudWatch, and custom VPC. Designed for minimal manual intervention and secure internal operations.

# Features

1. Single EC2-based infrastructure with automation
2. S3 for backups
3. CloudWatch for monitoring/logs
4. Secure custom VPC
5. Minimal manual intervention (<5%)

# Architecture

1. EC2 Instance (Bash automated provisioning)
2. Redis (In-memory service)
3. S3 (Backup and logs)
4. VPC (Custom subnets, routing, isolation)
5. IAM Roles (Fine-grained permission control)
6. CloudWatch (Log & metric monitoring)

# Tech Stack

- AWS EC2
- AWS S3
- AWS CloudWatch
- AWS VPC
- Redis
- Bash Scripting
- IAM

