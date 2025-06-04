#!/bin/bash

# Variables
DATE=$(date +%Y%m%d%H%M%S)
FILENAME="mongo_backup_$DATE.tar.gz"
TMP_DIR="/tmp/mongo_backup"
S3_PATH="s3://$S3_BUCKET_NAME/$FILENAME"

# Create and dump
mkdir -p "$TMP_DIR"
mongodump --host "$MONGO_HOST" --out "$TMP_DIR/mongodump"
tar -czvf "$TMP_DIR/$FILENAME" -C "$TMP_DIR" mongodump
rm -rf "$TMP_DIR/mongodump"

# Upload to S3
aws s3 cp "$TMP_DIR/$FILENAME" "$S3_PATH"

# Clean up
rm "$TMP_DIR/$FILENAME"
