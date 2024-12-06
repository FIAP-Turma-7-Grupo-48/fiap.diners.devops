# Network

# VPC

```sh
aws ec2 create-vpc --cidr-block 10.0.0.0/16 --output "text" --query "Vpc.VpcId"
````
```json
{
    "Vpc": {
        "CidrBlock": "10.0.0.0/16",
        "DhcpOptionsId": "dopt-01cde0f9653a58ed2",
        "State": "pending",
        "VpcId": "vpc-00ea71bb2fa2415fe",
        "OwnerId": "008152407463",
        "InstanceTenancy": "default",
        "Ipv6CidrBlockAssociationSet": [],
        "CidrBlockAssociationSet": [
            {
                "AssociationId": "vpc-cidr-assoc-04405932cb6ca640e",
                "CidrBlock": "10.0.0.0/16",
                "CidrBlockState": {
                    "State": "associated"
                }
            }
        ],
        "IsDefault": false
    }
}
```
## Subnets

### Private Subnet 1
```sh
aws ec2 create-subnet --vpc-id "vpc-00ea71bb2fa2415fe" --cidr-block 10.0.1.0/24 --availability-zone us-east-1a --output "text" --query "Subnet.SubnetId"
```

```json
{
    "Subnet": {
        "AvailabilityZone": "us-east-1a",
        "AvailabilityZoneId": "use1-az4",
        "AvailableIpAddressCount": 251,
        "CidrBlock": "10.0.1.0/24",
        "DefaultForAz": false,
        "MapPublicIpOnLaunch": false,
        "State": "available",
        "SubnetId": "subnet-04570f251274be1b0",
        "VpcId": "vpc-00ea71bb2fa2415fe",
        "OwnerId": "008152407463",
        "AssignIpv6AddressOnCreation": false,
        "Ipv6CidrBlockAssociationSet": [],
        "SubnetArn": "arn:aws:ec2:us-east-1:008152407463:subnet/subnet-04570f251274be1b0"
    }
}
```
### Private Subnet 2

```sh
aws ec2 create-subnet --vpc-id "vpc-00ea71bb2fa2415fe" --cidr-block 10.0.2.0/24 --availability-zone us-east-1b --output "text" --query "Subnet.SubnetId"
```

```json
{
    "Subnet": {
        "AvailabilityZone": "us-east-1b",
        "AvailabilityZoneId": "use1-az6",
        "AvailableIpAddressCount": 251,
        "CidrBlock": "10.0.2.0/24",
        "DefaultForAz": false,
        "MapPublicIpOnLaunch": false,
        "State": "available",
        "SubnetId": "subnet-07148fe87dff0c263",
        "VpcId": "vpc-00ea71bb2fa2415fe",
        "OwnerId": "008152407463",
        "AssignIpv6AddressOnCreation": false,
        "Ipv6CidrBlockAssociationSet": [],
        "SubnetArn": "arn:aws:ec2:us-east-1:008152407463:subnet/subnet-07148fe87dff0c263"
    }
}
```

### Private Subnet 1
```sh
aws ec2 create-subnet --vpc-id "vpc-00ea71bb2fa2415fe" --cidr-block 10.1.1.0/24 --availability-zone us-east-1a --output "text" --query "Subnet.SubnetId"
```

```json
{
    "Subnet": {
        "AvailabilityZone": "us-east-1a",
        "AvailabilityZoneId": "use1-az4",
        "AvailableIpAddressCount": 251,
        "CidrBlock": "10.0.1.0/24",
        "DefaultForAz": false,
        "MapPublicIpOnLaunch": false,
        "State": "available",
        "SubnetId": "subnet-04570f251274be1b0",
        "VpcId": "vpc-00ea71bb2fa2415fe",
        "OwnerId": "008152407463",
        "AssignIpv6AddressOnCreation": false,
        "Ipv6CidrBlockAssociationSet": [],
        "SubnetArn": "arn:aws:ec2:us-east-1:008152407463:subnet/subnet-04570f251274be1b0"
    }
}
```
### public Subnet 2

```sh
aws ec2 create-subnet --vpc-id "vpc-00ea71bb2fa2415fe" --cidr-block 10.1.2.0/24 --availability-zone us-east-1b --output "text" --query "Subnet.SubnetId"
```

```json
{
    "Subnet": {
        "AvailabilityZone": "us-east-1b",
        "AvailabilityZoneId": "use1-az6",
        "AvailableIpAddressCount": 251,
        "CidrBlock": "10.0.2.0/24",
        "DefaultForAz": false,
        "MapPublicIpOnLaunch": false,
        "State": "available",
        "SubnetId": "subnet-07148fe87dff0c263",
        "VpcId": "vpc-00ea71bb2fa2415fe",
        "OwnerId": "008152407463",
        "AssignIpv6AddressOnCreation": false,
        "Ipv6CidrBlockAssociationSet": [],
        "SubnetArn": "arn:aws:ec2:us-east-1:008152407463:subnet/subnet-07148fe87dff0c263"
    }
}
```

## Internet Gateway

```sh
aws ec2 create-internet-gateway -region us-east-1
```

```json

```

## Attach Internet Gateway to VPC

```sh
aws ec2 attach-internet-gateway -vpc-id vpc-XXXXXX -internet-gateway-id igw-XXXXXX -region us-east-1
```

```json

```

## Create Route Table

```sh
aws ec2 create-route-table -vpc-id vpc-XXXXXX -region us-east-1
```

```json

```

## Create Route Table

```sh
aws ec2 create-route-table -vpc-id vpc-XXXXXX -region us-east-1
```

```json

```

## Create Public Route Table

```sh
aws ec2 create-route -route-table-id rtb-XXXXXX - destination-cidr-block 0.0.0.0/0 -gateway-id igw-XXXXXX -region us-east-1

```

```json

```

## Associate Route Table to Subnet

```sh
aws ec2 create-route -route-table-id rtb-XXXXXX - destination-cidr-block 0.0.0.0/0 -gateway-id igw-XXXXXX -region us-east-1

```

```json

```

## Allocate Elastic IP

```sh
aws ec2 allocate-address --domain vpc
```

```json

```

## Create NAT Gateway and Associate it with public Subnet

```sh
aws ec2 create-nat-gateway --subnet-id subnet-XXXXXX --allocation-id eipalloc-XXXXXX
```

```json

```

## Security Group

```sh
aws ec2 create-security-group --group-name eks-node-group --description "EKS Node Group" --vpc-id "vpc-00ea71bb2fa2415fe" --output "text" --query "GroupId"
```

```json
{
    "GroupId": "sg-06cd8bfdadc807b3a"
}
```

### Authorize Security Group Ingresss (Inbound Trafic)

#### Port 22
```sh
aws ec2 authorize-security-group-ingress --group-id "sg-06cd8bfdadc807b3a" --protocol tcp --port 22 --cidr 0.0.0.0/0
```

#### Port 80
```sh
aws ec2 authorize-security-group-ingress --group-id "sg-06cd8bfdadc807b3a" --protocol tcp --port 80 --cidr 0.0.0.0/0
```

#### Port 443
```sh
aws ec2 authorize-security-group-ingress --group-id "sg-06cd8bfdadc807b3a" --protocol tcp --port 443 --cidr 0.0.0.0/0
```

# EKS Cluster

## Create Cluster

```sh
aws eks create-cluster --name eks-demo --role-arn "arn:aws:iam::008152407463:role/LabRole" --resources-vpc-config subnetIds=subnet-04570f251274be1b0,subnet-07148fe87dff0c263,securityGroupIds=sg-06cd8bfdadc807b3a
```

```json
{
    "cluster": {
        "name": "eks-demo",
        "arn": "arn:aws:eks:us-east-1:008152407463:cluster/eks-demo",
        "createdAt": "2024-12-06T04:29:06.823000-08:00",
        "version": "1.31",
        "roleArn": "arn:aws:iam::008152407463:role/LabRole",
        "resourcesVpcConfig": {
            "subnetIds": [
                "subnet-04570f251274be1b0",
                "subnet-07148fe87dff0c263"
            ],
            "securityGroupIds": [
                "sg-06cd8bfdadc807b3a"
            ],
            "vpcId": "vpc-00ea71bb2fa2415fe",
            "endpointPublicAccess": true,
            "endpointPrivateAccess": false,
            "publicAccessCidrs": [
                "0.0.0.0/0"
            ]
        },
        "kubernetesNetworkConfig": {
            "serviceIpv4Cidr": "172.20.0.0/16"
        },
        "logging": {
            "clusterLogging": [
                {
                    "types": [
                        "api",
                        "audit",
                        "authenticator",
                        "controllerManager",
                        "scheduler"
                    ],
                    "enabled": false
                }
            ]
        },
        "status": "CREATING",
        "certificateAuthority": {},
        "platformVersion": "eks.12",
        "tags": {}
    }
}
```

## Wait for cluster creation completition

```sh
aws eks wait cluster-active --name "eks-demo"
```

## Create Cluster SSH Key Pair

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

## Create Node Group

```sh
aws eks create-nodegroup --cluster-name eks-demo --nodegroup-name eks-demo-node-group --node-role "arn:aws:iam::008152407463:role/LabRole" --subnets "subnet-04570f251274be1b0" "subnet-07148fe87dff0c263" --scaling-config minSize=2,maxSize=2,desiredSize=2 --instance-types t3.medium --ami-type AL2_x86_64 --remote-access "ec2SshKey=MyKeyPair,sourceSecurityGroups=sg-06cd8bfdadc807b3a"
```

```json
{
    "nodegroup": {
        "nodegroupName": "eks-demo-node-group",
        "nodegroupArn": "arn:aws:eks:us-east-1:008152407463:nodegroup/eks-demo/eks-demo-node-group/04c9cdfd-20b4-fd34-a158-69eac37505d6",
        "clusterName": "eks-demo",
        "version": "1.31",
        "releaseVersion": "1.31.2-20241121",
        "createdAt": "2024-12-06T04:38:10.361000-08:00",
        "modifiedAt": "2024-12-06T04:38:10.361000-08:00",
        "status": "CREATING",
        "capacityType": "ON_DEMAND",
        "scalingConfig": {
            "minSize": 2,
            "maxSize": 2,
            "desiredSize": 2
        },
        "instanceTypes": [∏
            "t3.medium"
        ],
        "subnets": [
            "subnet-04570f251274be1b0",
            "subnet-07148fe87dff0c263"
        ],
        "remoteAccess": {
            "ec2SshKey": "MyKeyPair",
            "sourceSecurityGroups": [
                "sg-06cd8bfdadc807b3a"
            ]
        },
        "amiType": "AL2_x86_64",
        "nodeRole": "arn:aws:iam::008152407463:role/LabRole",
        "diskSize": 20,
        "health": {
            "issues": []
        },
        "tags": {}
    }
}
```

## Wait for cluster creation completition

```sh
aws eks wait nodegroup-active --name "eks-demo-node-group"
```


## kubectl - Install and Configure

```sh

```

```json

```

