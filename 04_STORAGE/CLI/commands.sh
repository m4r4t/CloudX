aws ec2 describe-instances --query "Reservations[*].Instances[*].[InstanceId,State.Name]" --profile epam_test --output table
aws s3 ls --recursive --profile epam_test