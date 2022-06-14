export AWS_PROFILE=epam
export BUCKET_NAME_1="iam-test-user1-6030"
export BUCKET_NAME_2="iam-test-other-user1-6030"
export ROLE_NAME="IAMBucketTestRole"
export POLICY_NAME="IAMBucketTestRole-Policy"
export INSTANCE_PROFILE_NAME="IAMBucketTestRole-profile"

#Create resorces
aws s3 mb s3://${BUCKET_NAME_1}
aws s3 mb s3://${BUCKET_NAME_2}
aws s3 cp role_policy.json s3://${BUCKET_NAME_1}
aws s3 cp devpolicy.json s3://${BUCKET_NAME_2}

#list customer managed policies
aws iam list-policies --scope Local 
aws iam create-role --role-name ${ROLE_NAME} --assume-role-policy-document file://role_trust_policy_ec2.json
aws iam create-policy --policy-name ${POLICY_NAME} --policy-document file://role_access_policy.json
aws iam attach-role-policy --role-name ${ROLE_NAME} --policy-arn "arn:aws:iam::047259566030:policy/IAMBucketTestRole-Policy"
#aws iam put-role-policy --role-name s3access --policy-name S3-Permissions  --policy-document file://ec2-role-access-policy.json
aws iam list-attached-role-policies --role-name ${ROLE_NAME}
aws iam create-instance-profile --instance-profile-name ${INSTANCE_PROFILE_NAME}
aws iam add-role-to-instance-profile --instance-profile-name ${INSTANCE_PROFILE_NAME} --role-name ${ROLE_NAME}
aws ec2 describe-iam-instance-profile-associations
aws ec2 replace-iam-instance-profile-association --association-id iip-assoc-032f43e8d2a5a4bb7 --iam-instance-profile Name=${INSTANCE_PROFILE_NAME}
aws ec2 associate-iam-instance-profile --instance-id i-036aba74b802d2a00 --iam-instance-profile Name=${INSTANCE_PROFILE_NAME}
aws ec2 disassociate-iam-instance-profile --association-id iip-assoc-02353eb7efb7f7121

#Cleaning Up
aws s3 rb s3://${BUCKET_NAME_1} --force
aws s3 rb s3://${BUCKET_NAME_2} --force
aws iam list-policies --scope Local
aws iam detach-role-policy --role-name ${ROLE_NAME} --policy-arn "arn:aws:iam::047259566030:policy/IAMBucketTestRole-Policy"
aws iam delete-policy --policy-arn "arn:aws:iam::047259566030:policy/IAMBucketTestRole-Policy"
aws iam delete-role --role-name ${ROLE_NAME}
aws iam list-roles | grep -i test