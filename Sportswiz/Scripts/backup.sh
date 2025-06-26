# -----------------------------------------
# 3. backup.sh - Backup Redis logs/data to S3 (cron job optional)
# -----------------------------------------

#!/bin/bash
set -e

TIMESTAMP=$(date +"%Y-%m-%d-%H-%M")
aws s3 cp /var/log/redis/redis.log s3://$BUCKET_NAME/redis-$TIMESTAMP.log

echo "Backup complete at $TIMESTAMP"
