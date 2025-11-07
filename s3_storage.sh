#!/bin/bash
# Simple Cloud Storage File (AWS S3)
# Individual Project- Group 2
# By Prisca Austine

BUCKET_NAME="prissy-771-storage"
REGION="us-east-1"
LOG_FILE="s3_log.txt"


echo "Creating bucket..."
aws s3api create-bucket --bucket $BUCKET_NAME --region $REGION
--create-bucket-configuration
LocationConstraint=$REGION >> $LOG_FILE 2>&1

echo "Turning off block public access..."
aws s3api put-public-access-block \
--bucket $BUCKET_NAME \
--public-access-block-configuration \

BlockPublicPolicy=false, BlockPublicAcls=false, IgnorePublicAcls=false, RestrictPublicBuckets=false >> $LOG_FILE 2>&1

echo "Applying public-read bucket policy..."
cat > policy.json <<EOL
{
  "Version":"2012-10-17",
  "Statement":[{
    "Sid":"PublicReadGetObject",
    "Effect":"Allow",
    "Principal": "*",
    "Action":["s3:GetObject"],
    "Resource":["arn:aws:s3:::$BUCKET_NAME/*"]
      }]
}
EOL

aws s3api put-bucket-policy --bucket $BUCKET_NAME --policy file://policy.json >> $LOG_FILE 

echo "Uploading capstone.txt..."
echo "This is a test file uploaded using bash automation." > test.txt
aws s3 cp capstone.txt s3://$BUCKET_NAME/ >> $LOG_FILE 2>&1

echo "Listing files in the bucket..."
aws s3 ls s3://$BUCKET_NAME/ | tee -a $LOG_FILE

echo "Downloading the file..."
aws s3 cp s3://$BUCKET_NAME/$FILE  >> $LOG_FILE 
echo "Downloaded capstone.txt"

echo "Deleting file..."
# aws s3 rm s3://$BUCKET_NAME/capstone.txt >> $LOG_FILE
echo "capstone.txt"


echo "Cloud storage setup completed successfully." 
echo "Check your log file ($LOG_FILE) for details."


