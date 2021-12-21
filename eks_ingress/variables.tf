
variable "cluster_name" { 
  default  = "eks_cluster"
  description = "Eks cluster name"
}

variable "fargate_namespace"{ 
  default  = "fargate"
  description = "Fargate namespace"
}