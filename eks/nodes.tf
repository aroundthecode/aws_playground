resource "aws_eks_node_group" "eks_node_group" {
  cluster_name    = aws_eks_cluster.eks_cluster.name
  node_group_name = "${var.cluster_name}-node_group"
  node_role_arn   = aws_iam_role.eks_node_group_role.arn
  subnet_ids      = [for s in aws_subnet.public : s.id]

  scaling_config {
    desired_size = 2
    max_size     = 2
    min_size     = 2
  }

  instance_types  = ["t3.micro"]
}


resource "aws_iam_role" "eks_node_group_role" {
  name = "${var.cluster_name}-node-group_role"

  assume_role_policy = jsonencode(
      {
        Version = "2012-10-17"
        Statement = [{
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
            Service = "ec2.amazonaws.com"
            }
        }]
    
    })

    managed_policy_arns = [
        "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy",
        "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy",
        "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
    ]
}

