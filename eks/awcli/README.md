# AWCLI EKS Multi Node Cluster Provisioning

----------

## Network

----------

### VPC

```sh
VPC_ID=$(aws ec2 create-vpc --cidr-block 10.0.0.0/16 --region us-east-1 --output "text" --query "Vpc.VpcId")
echo "VPC_ID=$VPC_ID" # >> $GITHUB_ENV
```

----------

### Subnets

#### Private Subnet 1

```sh
PRIVATE_SUBNET_ID=$(aws ec2 create-subnet --vpc-id $VPC_ID --cidr-block 10.0.1.0/24 --region us-east-1 --availability-zone us-east-1a --output "text" --query "Subnet.SubnetId")
echo "PRIVATE_SUBNET_ID=$PRIVATE_SUBNET_ID" # >> $GITHUB_ENV
```

#### Public Subnet

```sh
PUBLIC_SUBNET_ID=$(aws ec2 create-subnet --vpc-id $VPC_ID --cidr-block 10.0.100.0/24 --region us-east-1 --availability-zone us-east-1b --output "text" --query "Subnet.SubnetId")
echo "PUBLIC_SUBNET_ID=$PUBLIC_SUBNET_ID" # >> $GITHUB_ENV
```

----------

### Internet Gateway

```sh
INTERNET_GATEWAY_ID=$(aws ec2 create-internet-gateway --region us-east-1 --output "text" --query "InternetGateway.InternetGatewayId")
echo "INTERNET_GATEWAY_ID=$INTERNET_GATEWAY_ID" # >> $GITHUB_ENV
```

#### Attach Internet Gateway to VPC

```sh
aws ec2 attach-internet-gateway --internet-gateway-id $INTERNET_GATEWAY_ID --vpc-id $VPC_ID --region us-east-1
```

----------

### Allocate Elastic IP

```sh
EXTERNAL_IP_ALLOCATION_ID=$(aws ec2 allocate-address --domain vpc --region us-east-1 --output "text" --query "AllocationId")
echo "EXTERNAL_IP_ALLOCATION_ID=$EXTERNAL_IP_ALLOCATION_ID" # >> $GITHUB_ENV
```

----------

### Create NAT Gateway and Associate it with Public Subnet

```sh
NAT_GATEWAY_ID=$(aws ec2 create-nat-gateway --subnet-id $PUBLIC_SUBNET_ID --allocation-id $EXTERNAL_IP_ALLOCATION_ID --region us-east-1 --output "text" --query "NatGateway.NatGatewayId")
echo "NAT_GATEWAY_ID=$NAT_GATEWAY_ID" # >> $GITHUB_ENV
```

----------

### Routes

#### Create Route Table for Public Subnet

```sh
PUBLIC_ROUTE_TABLE_ID=$(aws ec2 create-route-table --vpc-id $VPC_ID --region us-east-1 --output "text" --query "RouteTable.RouteTableId")
echo "PUBLIC_ROUTE_TABLE_ID=$PUBLIC_ROUTE_TABLE_ID" # >> $GITHUB_ENV
```

#### Create Route Table for Private Subnet

```sh
PRIVATE_ROUTE_TABLE_ID=$(aws ec2 create-route-table --vpc-id $VPC_ID --region us-east-1 --output "text" --query "RouteTable.RouteTableId")
echo "PRIVATE_ROUTE_TABLE_ID=$PRIVATE_ROUTE_TABLE_ID" # >> $GITHUB_ENV
```

#### Create Route to the Internet Gateway

```sh
HAS_INTERNET_ROUTE_BEEN_CREATED=$(aws ec2 create-route --route-table-id $PUBLIC_ROUTE_TABLE_ID --destination-cidr-block 0.0.0.0/0 --gateway-id $INTERNET_GATEWAY_ID  --region us-east-1 --output "text" --query "Return")
echo "HAS_INTERNET_ROUTE_BEEN_CREATED=$HAS_INTERNET_ROUTE_BEEN_CREATED" # >> $GITHUB_ENV
```

#### Create Route to the NAT Gateway

```sh
HAS_NAT_ROUTE_BEEN_CREATED=$(aws ec2 create-route --region us-east-1 --route-table-id $PRIVATE_ROUTE_TABLE_ID --destination-cidr-block 0.0.0.0/0 --gateway-id $NAT_GATEWAY_ID --output "text" --query "Return")
echo "HAS_NAT_ROUTE_BEEN_CREATED=$HAS_NAT_ROUTE_BEEN_CREATED" # >> $GITHUB_ENV
```

#### Associate Route Table to Public Subnet

```sh
PUBLIC_ROUTE_TABLE_ASSOCIATION_ID=$(aws ec2 associate-route-table --region us-east-1 --route-table-id $PUBLIC_ROUTE_TABLE_ID --subnet-id $PUBLIC_SUBNET_ID --output "text" --query "AssociationId")
echo "PUBLIC_ROUTE_TABLE_ASSOCIATION_ID=$PUBLIC_ROUTE_TABLE_ASSOCIATION_ID" # >> $GITHUB_ENV
```

#### Associate Route Table to Private Subnet

```sh
PRIVATE_ROUTE_TABLE_ASSOCIATION_ID=$(aws ec2 associate-route-table --region us-east-1 --route-table-id $PRIVATE_ROUTE_TABLE_ID --subnet-id $PRIVATE_SUBNET_ID --output "text" --query "AssociationId")
echo "PRIVATE_ROUTE_TABLE_ASSOCIATION_ID=$PRIVATE_ROUTE_TABLE_ASSOCIATION_ID" # >> $GITHUB_ENV
```

----------

### Security Group

```sh
SECURITY_GROUP_ID=$(aws ec2 create-security-group --region us-east-1 --group-name eks-security-group --description "EKS Security Group" --vpc-id $VPC_ID --output "text" --query "GroupId")
echo "SECURITY_GROUP_ID=$SECURITY_GROUP_ID" # >> $GITHUB_ENV
```

#### Authorize Security Group Ingresss (Inbound Trafic)

##### Port 22

```sh
HAS_SSH_BEEN_AUTHORIZED_TO_SECURITY_GROUP=$(aws ec2 authorize-security-group-ingress --region us-east-1 --group-id $SECURITY_GROUP_ID --protocol tcp --port 22 --cidr 0.0.0.0/0 --output "text" --query "Return")
echo "HAS_SSH_BEEN_AUTHORIZED_TO_SECURITY_GROUP=$HAS_SSH_BEEN_AUTHORIZED_TO_SECURITY_GROUP" # >> $GITHUB_ENV
```

##### Port 80

```sh
HAS_HTTP_BEEN_AUTHORIZED_TO_SECURITY_GROUP=$(aws ec2 authorize-security-group-ingress --region us-east-1 --group-id $SECURITY_GROUP_ID --protocol tcp --port 80 --cidr 0.0.0.0/0 --output "text" --query "Return")
echo "HAS_HTTP_BEEN_AUTHORIZED_TO_SECURITY_GROUP=$HAS_HTTP_BEEN_AUTHORIZED_TO_SECURITY_GROUP" # >> $GITHUB_ENV
```

##### Port 443

```sh
HAS_HTTPS_BEEN_AUTHORIZED_TO_SECURITY_GROUP=$(aws ec2 authorize-security-group-ingress --region us-east-1 --group-id $SECURITY_GROUP_ID --protocol tcp --port 443 --cidr 0.0.0.0/0 --output "text" --query "Return")
echo "HAS_SSH_BEEN_AUTHORIZED_TO_SECURITY_GROUP=$HAS_SSH_BEEN_AUTHORIZED_TO_SECURITY_GROUP" # >> $GITHUB_ENV
```

----------

### Create Cluster SSH Key Pair

```sh
aws ec2 create-key-pair --region us-east-1 --key-name eks-nodes-key-pair --output "text" --query "KeyPairId"
```

----------


## Retrieve Arn for Role "LabRole" (AWS Academy limitation)

```sh
LABROLE_ARN=$(aws iam list-roles --output text --query "Roles[?RoleName=='LabRole'].Arn")
echo "LABROLE_ARN=$LABROLE_ARN" # >> $GITHUB_ENV
```

## EKS Cluster

### Create Cluster

```sh
aws eks create-cluster --region us-east-1 --name eks-cluster --role-arn $LABROLE_ARN --resources-vpc-config subnetIds=$PUBLIC_SUBNET_ID,$PRIVATE_SUBNET_ID,securityGroupIds=$SECURITY_GROUP_ID
```

### Wait for Cluster creation completition

```sh
aws eks wait cluster-active --region us-east-1 --name "eks-cluster"
```

----------

### Create Node Group

```sh
aws eks create-nodegroup --region us-east-1 --cluster-name eks-cluster --nodegroup-name eks-node-group --node-role "arn:aws:iam::008152407463:role/LabRole" --subnets $PRIVATE_SUBNET_ID --scaling-config minSize=2,maxSize=2,desiredSize=2 --instance-types t3.medium --ami-type AL2_x86_64 --remote-access "ec2SshKey=eks-nodes-key-pair,sourceSecurityGroups=$SECURITY_GROUP_ID"
```

### Wait for Node Group creation completition

```sh
aws eks wait nodegroup-active --region us-east-1 --cluster-name eks-cluster --nodegroup-name eks-node-group
```

----------

### kubectl - Install and Configure

```sh

```

```json

```

