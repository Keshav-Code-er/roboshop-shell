#/bin/bash

NAME=("mongodb" "ansible" "node1" "node2")
INSTANCE_TYPE="t2.micro"
IMAGE_ID=ami-0b4f379183e5706b9
SECURITY_GROUP_ID=sg-097e3f743552a558f
DOMAIN_NAME=joindevops.shop

echo "creating $i instance"
IP_ADDRESS=$(aws ec2 run-instances --image-id $IMAGE_ID --instance-type $INSTANCE_TYPE --security-group-id $SECURITY_GROUP_ID --subnet-id subnet-072dcbe4b0900b65a --query 'Instances[0].InstanceId' --output text)
echo "create $i instance: $IP_ADDRESS"

aws route53 change-resource-record-sets --hosted-zone-id Z067392810YPGBIPOHNIP --change-batch '
{
     "Changes": [{
      "Action"              : "CREATE",
      "ResourceRecordSet"  : {
        "Name"              : "'$i.$DOMAIN_NAME'",
        "Type"             : "A",
        "TTL"              : 1,
        "ResourceRecords"  : [{"Value" : "'$IP_ADDRESS'"}]
        }}]
}
'