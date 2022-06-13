export AWS_PROFILE=epam
export POLICY_NAME="DevPolicy"
export USER_NAME="dev-user"
export GROUP_NAME="dev-group"
export PAZZ="Sup3rC00lP4zz"

#aws sts get-caller-identity   --profile epam
aws sts get-caller-identity 



#Create users, groups, policies
aws iam create-policy --policy-name ${POLICY_NAME} --policy-document file://devpolicy.json  --description "IAM policy for DevGroup"
aws iam create-group --group-name ${GROUP_NAME}
POLICY_ARN=$(aws iam list-policies --query "Policies[?PolicyName=='${POLICY_NAME}'].Arn" --output text)
aws iam attach-group-policy --group-name ${GROUP_NAME} --policy-arn ${POLICY_ARN}
aws iam create-user --user-name ${USER_NAME}
aws iam add-user-to-group --user-name ${USER_NAME} --group-name ${GROUP_NAME}
aws iam create-access-key --user-name ${USER_NAME}
aws iam create-login-profile --user-name ${USER_NAME} --password ${PAZZ} --no-password-reset-required


#Clean UP 
aws iam list-policies --query "Policies[?PolicyName=='${POLICY_NAME}'].Arn" --output text
POLICY_ARN=$(aws iam list-policies --query "Policies[?PolicyName=='${POLICY_NAME}'].Arn" --output text)
aws iam detach-group-policy --group-name ${GROUP_NAME} --policy-arn ${POLICY_ARN}
aws iam delete-policy --policy-arn ${POLICY_ARN}

aws iam list-groups --query "Groups[?GroupName=='${GROUP_NAME}'].Arn" --output text
GROUP_ARN=$(aws iam list-groups --query "Groups[?GroupName=='${GROUP_NAME}'].Arn" --output text)
aws iam delete-group --group-name ${GROUP_NAME}
 
aws iam list-users --query "Users[?UserName=='${USER_NAME}'].Arn" --output text
USER_ARN=$(aws iam list-users --query "Users[?UserName=='${USER_NAME}'].Arn" --output text)
aws iam remove-user-from-group --group-name ${GROUP_NAME} --user-name ${USER_NAME}
ACCESS_KEY_ID=$(aws iam list-access-keys --user-name ${USER_NAME} --query "AccessKeyMetadata[?UserName=='${USER_NAME}'].AccessKeyId" --output text)
aws iam delete-access-key --user-name ${USER_NAME} --access-key-id ${ACCESS_KEY_ID}
aws iam delete-login-profile --user-name ${USER_NAME}
aws iam delete-user --user-name ${USER_NAME}


