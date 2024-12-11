# AWCLI EKS Multi Node Cluster Provisioning

## Network

### VPC

```sh
VPC_ID=$(aws ec2 create-vpc --cidr-block 10.0.0.0/16 --output "text" --query "Vpc.VpcId")
echo "VPC_ID=$VPC_ID" >> $GITHUB_ENV
```

### Subnets

#### Private Subnet 1

```sh
PRIV_SUBNET_ID_1=$(aws ec2 create-subnet --vpc-id $VPC_ID --cidr-block 10.0.1.0/24 --availability-zone us-east-1a --output "text" --query "Subnet.SubnetId")
echo "PRIV_SUBNET_ID_1=$PRIV_SUBNET_ID_1" >> $GITHUB_ENV
```

#### Private Subnet 2

```sh
PRIV_SUBNET_ID_2=$(aws ec2 create-subnet --vpc-id $VPC_ID --cidr-block 10.0.2.0/24 --availability-zone us-east-1b --output "text" --query "Subnet.SubnetId")
echo "PRIV_SUBNET_ID_2=$PRIV_SUBNET_ID_2" >> $GITHUB_ENV
```

#### Public Subnet 1

```sh
PUB_SUBNET_ID_1=$(aws ec2 create-subnet --vpc-id $VPC_ID --cidr-block 10.1.1.0/24 --availability-zone us-east-1a --output "text" --query "Subnet.SubnetId")
echo "PUB_SUBNET_ID_1=$PUB_SUBNET_ID_1" >> $GITHUB_ENV
```

#### Public Subnet 2

```sh
PUB_SUBNET_ID_2=$(aws ec2 create-subnet --vpc-id $VPC_ID --cidr-block 10.1.2.0/24 --availability-zone us-east-1b --output "text" --query "Subnet.SubnetId")
echo "PUB_SUBNET_ID_2=$PUB_SUBNET_ID_2" >> $GITHUB_ENV
```

### Internet Gateway

```sh
INTERNET_GATEWAY_ID=$(aws ec2 create-internet-gateway -region us-east-1 --query "InternetGateway.InternetGatewayId")
echo "INTERNET_GATEWAY_ID=$INTERNET_GATEWAY_ID" >> $GITHUB_ENV
```

#### Attach Internet Gateway to VPC

```sh
aws ec2 attach-internet-gateway -vpc-id $VPC_ID -internet-gateway-id $INTERNET_GATEWAY_ID -region us-east-1
```

### Routes

#### Create Route Table

```sh
ROUTE_TABLE_ID=$(aws ec2 create-route-table -vpc-id $VPC_ID -region us-east-1 --query "RouteTable.RouteTableId")
echo "ROUTE_TABLE_ID=$ROUTE_TABLE_ID" >> $GITHUB_ENV
```

#### Create Public Route Table

```sh
PUBLIC_ROUTE_CREATED=$(aws ec2 create-route -route-table-id $ROUTE_TABLE_ID - destination-cidr-block 0.0.0.0/0 -gateway-id $INTERNET_GATEWAY_ID -region us-east-1)
echo "PUBLIC_ROUTE_CREATED=$PUBLIC_ROUTE_CREATED" >> $GITHUB_ENV
```

#### Associate Route Table to Subnet

```sh
aws ec2 create-route -route-table-id rtb-XXXXXX - destination-cidr-block 0.0.0.0/0 -gateway-id $INTERNET_GATEWAY_ID -region us-east-1

```

### Allocate Elastic IP

```sh
aws ec2 allocate-address --domain vpc
```

### Create NAT Gateway and Associate it with public Subnet

```sh
aws ec2 create-nat-gateway --subnet-id subnet-XXXXXX --allocation-id eipalloc-XXXXXX
```

### Security Group

```sh
aws ec2 create-security-group --group-name eks-node-group --description "EKS Node Group" --vpc-id $VPC_ID --output "text" --query "GroupId"
```

#### Authorize Security Group Ingresss (Inbound Trafic)

##### Port 22

```sh
aws ec2 authorize-security-group-ingress --group-id "sg-06cd8bfdadc807b3a" --protocol tcp --port 22 --cidr 0.0.0.0/0
```

##### Port 80

```sh
aws ec2 authorize-security-group-ingress --group-id "sg-06cd8bfdadc807b3a" --protocol tcp --port 80 --cidr 0.0.0.0/0
```

##### Port 443

```sh
aws ec2 authorize-security-group-ingress --group-id "sg-06cd8bfdadc807b3a" --protocol tcp --port 443 --cidr 0.0.0.0/0
```

----------

## EKS Cluster

### Create Cluster

```sh
aws eks create-cluster --name eks-demo --role-arn "arn:aws:iam::008152407463:role/LabRole" --resources-vpc-config subnetIds=subnet-04570f251274be1b0,subnet-07148fe87dff0c263,securityGroupIds=sg-06cd8bfdadc807b3a
```

### Wait for cluster creation completition

```sh
aws eks wait cluster-active --name "eks-demo"
```

----------

### Create Cluster SSH Key Pair

```sh
aws ec2 create-key-pair --key-name MyKeyPair
```

```json
{
    "KeyFingerprint": "5f:ae:f5:ac:69:ba:fa:e5:2b:51:25:3a:54:ea:40:a6:3a:96:cc:d5",
    "KeyMaterial": "-----BEGIN RSA PRIVATE KEY-----\nMIIEowIBAAKCAQEA1t5Ai21Agw1JC66T0KW+prLeRIVI9GixpWZp4Kt3BrATtABI\nOveW0e++AAImSGwhLsepQABcFh7CtU4UNEF9FOkzuuz9OF5c5eLvpnOQImgEahg3\nf7+twcDUFNf5SagDXqkfW0JZ3KScotdYaBSMrt+1xE/aL8H56VINm2yM1RJqEkI+\nLVUaCutVgUWFU90NFrzwuOs3v8aB2freR+ZCwm8ZfwScXTD7/gd3Wkbcfi9wkm8c\nDfetY70vf47uy4rgQfSYiTXPUqq3sRYDAdOnZAZpfA8Ivur/2d8PhIYNw3gUlz19\noYbMYwmrwAL51DAnXfwqjyd1kPq4irOzcXz31wIDAQABAoIBADdEWYPDaTmMPEKl\n991OFJjaHzOuuNIs76ykiA1C7U2qEpdVDz8jmgaLzOpBo0kzjuFyd8U/knAaH2j1\nGVtLkPnE9gpZlNRf6TM0SQIebW98I86KRhQ04GOazrJBzxwz/BHoHGmjymtnZ+a2\nz0WOK5V7c0x4YZ2xHi/2bAuTQzI2nm/IZTVZpKY56ISz/gXYfqPiw/Kp/Nj+L3TK\n55Lywjmzeqdr6b9e9zndP/GCvIJU/qKVuuBnUj9StIhMGxecqUO2f22uiunYRiK+\nOAGpc5qLoSbHZxbrjJntv4rYevt50O/fMhagcyPCEDM7vPnbi3qOYYoWFpDrOt5y\n00EA+2ECgYEA+cH9C9rkgqfq0WCcckW426+0DNjtS6V2xVF+PqZCIKSlirj6tlpm\nkSpW7ya/rD7BByAiye/HjZ3aaQnc+UsKH2Qbx4DHlq/cd7A5tYf3bgp6IbBzNMeO\nrQnpqLALVl30ewcFkYygBOcnm3s5DNw3O63uq3J94dvf/oOvBhQRV2cCgYEA3D0I\nDjo4MD3U/sufgtSyqn6RWA+WawRpdKfLyRuwx/JbtTZZlHCEnFpXdznxEaVTVbH0\nZhIwBeppBtXoVg/9SP5J//jN06t1i6mfnvQqefQZIBOGHPp21NE6nWqsl3mb5GCL\nuOfVsqj0JsFpI3Lx/Y+OO0v9SmbZ4hwSTdgQRhECgYBnkuUHh40ACfa9QZ1fXj6d\nDC5UrZkqp8GrbnI2NOhzdRQZhUCjYrXqOW632o/eNGAEPnVu3PsaZX3v1WFIGLBn\n+DH0+BjNCr0Y/YHRIEOh5MJlOjFsj91BMT0u8WKiPHBonK7Yf0LVBa9NMTqldKWL\nIEQ74U0G3xHzEFUC5kuSvQKBgGY9jvfL3znF+pMuRCagRzEPALo4wkN8ENiu7NO3\nnyGzSQ+e44cdlPJgniojI95lOYKW0jZwSwrz/z3FH86ULaktI31JK4QQHMlxPUC1\naOKkhuV1KtVZEMFLQELDusu3EL+8ciCsv2/pLy6uqvhh7CUh941fgX6AsLVfAsBQ\nhX2BAoGBALjbxARnFxP0jAQVNrdnzNfFnVerPDZoH1yoRJNtu1xr7Od6IxUeVdTd\n6fdav5i9xN8lYHSaPBXurC9qCHs+67FN5y/aAQAftE3pni+7YJh6lap5rjwD/ZZC\nmOL3BwmXqBjrjSAmiql7m1GtNKO8iwWwwBKfMz9Wv70KLQ/iwj+Y\n-----END RSA PRIVATE KEY-----",
    "KeyName": "MyKeyPair",
    "KeyPairId": "key-0dc54e81940bb14d3"
}
```

----------

### Create Node Group

```sh
aws eks create-nodegroup --cluster-name eks-demo --nodegroup-name eks-demo-node-group --node-role "arn:aws:iam::008152407463:role/LabRole" --subnets "subnet-04570f251274be1b0" "subnet-07148fe87dff0c263" --scaling-config minSize=2,maxSize=2,desiredSize=2 --instance-types t3.medium --ami-type AL2_x86_64 --remote-access "ec2SshKey=MyKeyPair,sourceSecurityGroups=sg-06cd8bfdadc807b3a"
```

### Wait for cluster creation completition

```sh
aws eks wait nodegroup-active --name "eks-demo-node-group"
```

----------


### kubectl - Install and Configure

```sh

```

```json

```

