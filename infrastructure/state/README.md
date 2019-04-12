# It's a chicken and egg scenario

You have to store remote state. But you have nowhere to store it.

## Two options (we chose the first)

1. Manually execute TF to create an S3 Bucket and DynamoDB table, check in files
2. Have something else do above

## There is nothing sensitive about the state

The creation of the bucket/table is not sensitive. However, S3 bucket names are a global, quasi-regional resource.

Be careful what you name buckets, and frequent create/destroy could be problematic due to DNS
