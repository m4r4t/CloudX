export AWS_DEFAULT_PROFILE="epam_test"
aws ec2 create-vpc --cidr-block 10.0.0.0/16 --tag-specifications ResourceType=vpc,Tags='[{Key=Env,Value="Test"},{Key=Name,Value="Created by CLI"}]'

aws ec2 describe-availability-zones --output json

aws ec2 create-subnet --cidr-block 10.0.1.0/24 --vpc-id vpc-0fcc070b3146b60de --availability-zone eu-west-1a --tag-specifications ResourceType=subnet,Tags='[{Key=Env,Value="Test"},{Key=Name,Value="Created by CLI"}]'
aws ec2 create-subnet --cidr-block 10.0.2.0/24 --vpc-id vpc-0fcc070b3146b60de --availability-zone eu-west-1b --tag-specifications ResourceType=subnet,Tags='[{Key=Env,Value="Test"},{Key=Name,Value="Created by CLI"}]'
aws ec2 create-subnet --cidr-block 10.0.3.0/24 --vpc-id vpc-0fcc070b3146b60de --availability-zone eu-west-1c --tag-specifications ResourceType=subnet,Tags='[{Key=Env,Value="Test"},{Key=Name,Value="Created by CLI"}]'


#CLEAN_UP
aws ec2 delete-vpc --vpc-id vpc-065bc24f28eb8f7af