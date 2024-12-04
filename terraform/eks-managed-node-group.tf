module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.0"

  cluster_name    = "eks-cluster-fiap-turma-7-grupo-48"
  cluster_version = "1.31"

  bootstrap_self_managed_addons = false
  cluster_addons = {
    coredns                = {}
    eks-pod-identity-agent = {}
    kube-proxy             = {}
    vpc-cni                = {}
  }

  # Optional
  cluster_endpoint_public_access = true

  # Optional: Adds the current caller identity as an administrator via cluster access entry
  enable_cluster_creator_admin_permissions = true

  vpc_id                   = "vpc-fiap-turma-7-grupo-48"
  subnet_ids               = ["subnet-fiap-turma-7-grupo-48-1", "subnet-fiap-turma-7-grupo-48-2", "subnet-fiap-turma-7-grupo-48-3"]
  control_plane_subnet_ids = ["subnet-control-plane-fiap-turma-7-grupo-48-1", "subnet-control-plane-fiap-turma-7-grupo-48-2", "subnet-control-plane-fiap-turma-7-grupo-48-3"]

  # EKS Managed Node Group(s)
  eks_managed_node_group_defaults = {
    instance_types = ["m6i.large", "m5.large", "m5n.large", "m5zn.large"]
  }

  eks_managed_node_groups = {
    create_iam_roles = true
    eks-cluster-fiap-turma-7-grupo-48 = {
      # Starting on 1.30, AL2023 is the default AMI type for EKS managed node groups
      ami_type       = "AL2023_x86_64_STANDARD"
      instance_types = ["m5.xlarge"]

      min_size     = 2
      max_size     = 10
      desired_size = 2

      create_node_iam_role= true
    }
  }

  tags = local.tags
}