variable "aws_region" {
  type = string
  default = "sa-east-1"
}

variable "base_name" {
  type = string
  default = "fiap-soat-t7-g48"
}

variable "cluster_name" {
  type = string
  default = "eks-cluster-fiap-soat-t7-g48"
}

variable "node_group_base_name" {
  type = string
  default = "eks-nodegroup-fiap-soat-t7-g48"
}


variable "node_base_name" {
  type = string
  default = "eks-node-fiap-soat-t7-g48"
}

variable "vpc_name" {
  type = string
  default = "vpc-fiap-soat-t7-g48"
}

variable "internet_gateway_name" {
  type = string
  default = "vpc-fiap-soat-t7-g48"
}