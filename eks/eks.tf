resource "aws_eks_cluster" "eks_cluster" {
  name     = "${var.cluster_name}"
   
  role_arn = aws_iam_role.eks_cluster_role.arn
  enabled_cluster_log_types = ["api", "audit", "authenticator", "controllerManager", "scheduler"]
  
   vpc_config {
    subnet_ids =  concat(
        [for s in aws_subnet.public : s.id],
        [for s in aws_subnet.private : s.id]
    )
  }
   
   timeouts {
     delete    = "30m"
   }

   tags = {
        Name   = "${var.cluster_name}-eks-cluster"
        project = "eks"
    }
}


resource "aws_iam_role" "eks_cluster_role" {
  name = "${var.cluster_name}-cluster-role"
  description = "Allow cluster to manage node groups, fargate nodes and cloudwatch logs"
  force_detach_policies = true
  assume_role_policy = jsonencode({

    Version: "2012-10-17",
    Statement: [
        {
        Effect: "Allow",
        Principal: {
            Service: [
                "eks.amazonaws.com",
                "eks-fargate-pods.amazonaws.com"
            ]
        },
        Action: "sts:AssumeRole"
        }
    ]
    })
}

resource "aws_iam_role_policy_attachment" "AmazonEKSClusterPolicy1"{
    policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
    role       = aws_iam_role.eks_cluster_role.name
}

resource "aws_iam_role_policy_attachment" "AmazonEKSVPCResourceController1" {
    policy_arn = "arn:aws:iam::aws:policy/AmazonEKSVPCResourceController"
    role       = aws_iam_role.eks_cluster_role.name
}