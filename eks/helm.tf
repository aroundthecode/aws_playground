provider "helm" {
  kubernetes {
    host                   = aws_eks_cluster.eks_cluster.endpoint
    cluster_ca_certificate = base64decode(aws_eks_cluster.eks_cluster.certificate_authority.0.data)
    exec {
      api_version = "client.authentication.k8s.io/v1alpha1"
      args        = ["eks", "get-token", "--cluster-name", aws_eks_cluster.eks_cluster.name]
      command     = "aws"
    }
  }
} 

data "aws_eks_cluster_auth" "cluster_auth" {
  name = aws_eks_cluster.eks_cluster.name
}


resource "local_file" "kubectl" {
    content     = templatefile("kubeconfig.tpl", 
        {
            cad = aws_eks_cluster.eks_cluster.certificate_authority[0].data
            endpoint = aws_eks_cluster.eks_cluster.endpoint
            name = aws_eks_cluster.eks_cluster.name
            token = data.aws_eks_cluster_auth.cluster_auth.token
        } )
    filename = "kubeconfig.yaml"
}