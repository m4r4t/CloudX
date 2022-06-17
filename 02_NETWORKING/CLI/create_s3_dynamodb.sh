aws s3 mb s3://tfstate-8015 --profile gmail

aws dynamodb create-table --table-name tf-locks \
                          --attribute-definition AttributeName=LockID,AttributeType=S \
                          --key-schema AttributeName=LockID,KeyType=HASH \
                          --billing-mode PAY_PER_REQUEST \
                          --profile gmail


 aws dynamodb scan --table-name "tf-locks" --profile gmail