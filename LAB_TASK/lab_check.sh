#!/bin/bash

REGION=eu-west-1
LB=ghost-alb
LBARN=$(aws elbv2 describe-load-balancers --region $REGION --names $LB --profile epam_test | jq -r '.LoadBalancers[].LoadBalancerArn')
for i in  $(aws elbv2 describe-target-groups --load-balancer-arn $LBARN  --region $REGION --profile epam_test | jq -r '.TargetGroups[].TargetGroupArn'); 
do 
   aws elbv2 describe-target-health --target-group-arn $i --region $REGION --profile epam_test; 
done
