#/bin/bash

NAME=("node07" "node08")
INSTANCE_TYPE="t2.micro"
IMAGE_ID=ami-0b4f379183e5706b9
SECURITY_GROUP_ID=sg-097e3f743552a558f
DOMAIN_NAME=joindevops.shop

for i in "${NAME[@]}"; do
  echo "creating $i instance"
  IP_ADDRESS=$(aws ec2 run-instances --image-id $IMAGE_ID --instance-type $INSTANCE_TYPE --security-group-ids $SECURITY_GROUP_ID --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=$i}]" | jq -r '.Instances[0].PrivateIpAddress')
  echo "created $i instance: $IP_ADDRESS"

  aws route53 change-resource-record-sets --hosted-zone-id Z067392810YPGBIPOHNIP --change-batch '
{
            "Changes": [{
            "Action": "CREATE",
                        "ResourceRecordSet": {
                                    "Name": "'$i.$DOMAIN_NAME'",
                                    "Type": "A",
                                    "TTL": 300,
                                 "ResourceRecords": [{ "Value": "'$IP_ADDRESS'"}]
    }}]
    }
    '
done