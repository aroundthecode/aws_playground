data aws_eks_cluster eks_cluster{
    name = var.cluster_name
}

data "aws_eks_cluster_auth" "cluster_auth" {
  name = data.aws_eks_cluster.eks_cluster.name
}

