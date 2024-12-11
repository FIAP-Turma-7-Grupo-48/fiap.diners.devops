
# IAM role for eks

resource "aws_iam_role" "fiap-soat-t7-g48" {
  name = "${var.cluster_name}"
  tags = {
    tag-key = "${var.cluster_name}"
  }

  assume_role_policy = <<POLICY
  {
      "Version": "2012-10-17",
      "Statement": [
          {
              "Effect": "Allow",
              "Principal": {
                  "Service": [
                      "eks.amazonaws.com"
                  ]
              },
              "Action": "sts:AssumeRole"
          }
      ]
  }
  POLICY
}

# eks policy attachment
resource "aws_iam_role_policy_attachment" "fiap-soat-t7-g48-AmazonEKSClusterPolicy" {
  role       = aws_iam_role.fiap-soat-t7-g48.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}

# bare minimum requirement of eks

resource "aws_eks_cluster" "fiap-soat-t7-g48" {
  name     = "fiap-soat-t7-g48"
  role_arn = aws_iam_role.fiap-soat-t7-g48.arn

  vpc_config {
    subnet_ids = [
      aws_subnet.private-sa-east-1a.id,
      aws_subnet.private-sa-east-1b.id,
      aws_subnet.public-sa-east-1a.id,
      aws_subnet.public-sa-east-1b.id
    ]
  }

  depends_on = [aws_iam_role_policy_attachment.fiap-soat-t7-g48-AmazonEKSClusterPolicy]
}