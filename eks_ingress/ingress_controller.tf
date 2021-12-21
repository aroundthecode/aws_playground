resource "aws_iam_policy" "ALB-policy" {
  name   = "ALBIngressControllerIAMPolicy"
  # https://raw.githubusercontent.com/kubernetes-sigs/aws-load-balancer-controller/v2.3.1/docs/install/iam_policy.json
  policy = jsonencode({
	"Version": "2012-10-17",
	"Statement": [{
			"Effect": "Allow",
			"Action": "iam:CreateServiceLinkedRole",
			"Resource": "*",
			"Condition": {
				"StringEquals": {
					"iam:AWSServiceName": "elasticloadbalancing.amazonaws.com"
				}
			}
		},
		{
			"Effect": "Allow",
			"Action": [
				"ec2:DescribeAccountAttributes",
				"ec2:DescribeAddresses",
				"ec2:DescribeAvailabilityZones",
				"ec2:DescribeInternetGateways",
				"ec2:DescribeVpcs",
				"ec2:DescribeVpcPeeringConnections",
				"ec2:DescribeSubnets",
				"ec2:DescribeSecurityGroups",
				"ec2:DescribeInstances",
				"ec2:DescribeNetworkInterfaces",
				"ec2:DescribeTags",
				"ec2:GetCoipPoolUsage",
				"ec2:DescribeCoipPools",
				"elasticloadbalancing:DescribeLoadBalancers",
				"elasticloadbalancing:DescribeLoadBalancerAttributes",
				"elasticloadbalancing:DescribeListeners",
				"elasticloadbalancing:DescribeListenerCertificates",
				"elasticloadbalancing:DescribeSSLPolicies",
				"elasticloadbalancing:DescribeRules",
				"elasticloadbalancing:DescribeTargetGroups",
				"elasticloadbalancing:DescribeTargetGroupAttributes",
				"elasticloadbalancing:DescribeTargetHealth",
				"elasticloadbalancing:DescribeTags"
			],
			"Resource": "*"
		},
		{
			"Effect": "Allow",
			"Action": [
				"cognito-idp:DescribeUserPoolClient",
				"acm:ListCertificates",
				"acm:DescribeCertificate",
				"iam:ListServerCertificates",
				"iam:GetServerCertificate",
				"waf-regional:GetWebACL",
				"waf-regional:GetWebACLForResource",
				"waf-regional:AssociateWebACL",
				"waf-regional:DisassociateWebACL",
				"wafv2:GetWebACL",
				"wafv2:GetWebACLForResource",
				"wafv2:AssociateWebACL",
				"wafv2:DisassociateWebACL",
				"shield:GetSubscriptionState",
				"shield:DescribeProtection",
				"shield:CreateProtection",
				"shield:DeleteProtection"
			],
			"Resource": "*"
		},
		{
			"Effect": "Allow",
			"Action": [
				"ec2:AuthorizeSecurityGroupIngress",
				"ec2:RevokeSecurityGroupIngress"
			],
			"Resource": "*"
		},
		{
			"Effect": "Allow",
			"Action": [
				"ec2:CreateSecurityGroup"
			],
			"Resource": "*"
		},
		{
			"Effect": "Allow",
			"Action": [
				"ec2:CreateTags"
			],
			"Resource": "arn:aws:ec2:*:*:security-group/*",
			"Condition": {
				"StringEquals": {
					"ec2:CreateAction": "CreateSecurityGroup"
				},
				"Null": {
					"aws:RequestTag/elbv2.k8s.aws/cluster": "false"
				}
			}
		},
		{
			"Effect": "Allow",
			"Action": [
				"ec2:CreateTags",
				"ec2:DeleteTags"
			],
			"Resource": "arn:aws:ec2:*:*:security-group/*",
			"Condition": {
				"Null": {
					"aws:RequestTag/elbv2.k8s.aws/cluster": "true",
					"aws:ResourceTag/elbv2.k8s.aws/cluster": "false"
				}
			}
		},
		{
			"Effect": "Allow",
			"Action": [
				"ec2:AuthorizeSecurityGroupIngress",
				"ec2:RevokeSecurityGroupIngress",
				"ec2:DeleteSecurityGroup"
			],
			"Resource": "*",
			"Condition": {
				"Null": {
					"aws:ResourceTag/elbv2.k8s.aws/cluster": "false"
				}
			}
		},
		{
			"Effect": "Allow",
			"Action": [
				"elasticloadbalancing:CreateLoadBalancer",
				"elasticloadbalancing:CreateTargetGroup"
			],
			"Resource": "*",
			"Condition": {
				"Null": {
					"aws:RequestTag/elbv2.k8s.aws/cluster": "false"
				}
			}
		},
		{
			"Effect": "Allow",
			"Action": [
				"elasticloadbalancing:CreateListener",
				"elasticloadbalancing:DeleteListener",
				"elasticloadbalancing:CreateRule",
				"elasticloadbalancing:DeleteRule"
			],
			"Resource": "*"
		},
		{
			"Effect": "Allow",
			"Action": [
				"elasticloadbalancing:AddTags",
				"elasticloadbalancing:RemoveTags"
			],
			"Resource": [
				"arn:aws:elasticloadbalancing:*:*:targetgroup/*/*",
				"arn:aws:elasticloadbalancing:*:*:loadbalancer/net/*/*",
				"arn:aws:elasticloadbalancing:*:*:loadbalancer/app/*/*"
			],
			"Condition": {
				"Null": {
					"aws:RequestTag/elbv2.k8s.aws/cluster": "true",
					"aws:ResourceTag/elbv2.k8s.aws/cluster": "false"
				}
			}
		},
		{
			"Effect": "Allow",
			"Action": [
				"elasticloadbalancing:AddTags",
				"elasticloadbalancing:RemoveTags"
			],
			"Resource": [
				"arn:aws:elasticloadbalancing:*:*:listener/net/*/*/*",
				"arn:aws:elasticloadbalancing:*:*:listener/app/*/*/*",
				"arn:aws:elasticloadbalancing:*:*:listener-rule/net/*/*/*",
				"arn:aws:elasticloadbalancing:*:*:listener-rule/app/*/*/*"
			]
		},
		{
			"Effect": "Allow",
			"Action": [
				"elasticloadbalancing:ModifyLoadBalancerAttributes",
				"elasticloadbalancing:SetIpAddressType",
				"elasticloadbalancing:SetSecurityGroups",
				"elasticloadbalancing:SetSubnets",
				"elasticloadbalancing:DeleteLoadBalancer",
				"elasticloadbalancing:ModifyTargetGroup",
				"elasticloadbalancing:ModifyTargetGroupAttributes",
				"elasticloadbalancing:DeleteTargetGroup"
			],
			"Resource": "*",
			"Condition": {
				"Null": {
					"aws:ResourceTag/elbv2.k8s.aws/cluster": "false"
				}
			}
		},
		{
			"Effect": "Allow",
			"Action": [
				"elasticloadbalancing:RegisterTargets",
				"elasticloadbalancing:DeregisterTargets"
			],
			"Resource": "arn:aws:elasticloadbalancing:*:*:targetgroup/*/*"
		},
		{
			"Effect": "Allow",
			"Action": [
				"elasticloadbalancing:SetWebAcl",
				"elasticloadbalancing:ModifyListener",
				"elasticloadbalancing:AddListenerCertificates",
				"elasticloadbalancing:RemoveListenerCertificates",
				"elasticloadbalancing:ModifyRule"
			],
			"Resource": "*"
		}
	]
})
}

resource "aws_iam_role" "eks_alb_ingress_controller" {
  name        = "eks-alb-ingress-controller"
  description = "Permissions required by the Kubernetes AWS ALB Ingress controller to do its job."

  force_detach_policies = true

  assume_role_policy = jsonencode(
  {
    "Version": "2012-10-17",
    "Statement": [
        {
        "Effect": "Allow",
        "Principal": {
            "Federated": "arn:aws:iam::${var.aws_account}:oidc-provider/${replace(data.aws_eks_cluster.eks_cluster.identity[0].oidc[0].issuer, "https://", "")}"
        },
        "Action": "sts:AssumeRoleWithWebIdentity",
        "Condition": {
            "StringEquals": {
            "${replace(data.aws_eks_cluster.eks_cluster.identity[0].oidc[0].issuer, "https://", "")}:sub": "system:serviceaccount:kube-system:alb-ingress-controller"
            }
        }
        }
    ]
  })
}


resource "aws_iam_role_policy_attachment" "ALB-policy_attachment" {
  policy_arn = aws_iam_policy.ALB-policy.arn
  role       = aws_iam_role.eks_alb_ingress_controller.name
}



data "tls_certificate" "auth" {
  url = data.aws_eks_cluster.eks_cluster.identity[0].oidc[0].issuer
}

resource "aws_iam_openid_connect_provider" "main" {
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = [data.tls_certificate.auth.certificates[0].sha1_fingerprint]
  url             = data.aws_eks_cluster.eks_cluster.identity[0].oidc[0].issuer
}




#####
# cluster role for the Ingress controller, a service account that’s bound to this role that has the previously created IAM role attached.
#####

resource "kubernetes_cluster_role" "ingress" {
  metadata {
    name = "alb-ingress-controller"
    labels = {
      "app.kubernetes.io/name"       = "alb-ingress-controller"
      "app.kubernetes.io/managed-by" = "terraform"
    }
  }

  rule {
    api_groups = ["", "extensions"]
    resources  = ["configmaps", "endpoints", "events", "ingresses", "ingresses/status", "services"]
    verbs      = ["create", "get", "list", "update", "watch", "patch"]
  }

  rule {
    api_groups = ["", "extensions"]
    resources  = ["nodes", "pods", "secrets", "services", "namespaces"]
    verbs      = ["get", "list", "watch"]
  }
}

resource "kubernetes_cluster_role_binding" "ingress" {
  metadata {
    name = "alb-ingress-controller"
    labels = {
      "app.kubernetes.io/name"       = "alb-ingress-controller"
      "app.kubernetes.io/managed-by" = "terraform"
    }
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = kubernetes_cluster_role.ingress.metadata[0].name
  }
  subject {
    kind      = "ServiceAccount"
    name      = kubernetes_service_account.ingress.metadata[0].name
    namespace = kubernetes_service_account.ingress.metadata[0].namespace
  }

  depends_on = [kubernetes_cluster_role.ingress]
}

resource "kubernetes_service_account" "ingress" {
  automount_service_account_token = true
  metadata {
    name      = "alb-ingress-controller"
    namespace = "kube-system"
    labels    = {
      "app.kubernetes.io/name"       = "alb-ingress-controller"
      "app.kubernetes.io/managed-by" = "terraform"
    }
    annotations = {
      "eks.amazonaws.com/role-arn" = aws_iam_role.eks_alb_ingress_controller.arn
    }
  }
}


#####
# Ingress controller deployment
#####

# deploy CRD first
resource "kubernetes_manifest" "ingressclass" {
  manifest = yamldecode(file("helm/ingressclassparams.elbv2.k8s.aws.yaml"))
}

resource "kubernetes_manifest" "targetgroupbindings" {
  manifest = yamldecode(file("helm/targetgroupbindings.elbv2.k8s.aws.yaml"))
}


# Helm chart then
resource "helm_release" "alb-ingress-controller" {
  name       = "alb-ingress-controller"
  repository = "https://aws.github.io/eks-charts"
  chart      = "aws-load-balancer-controller"
  version    = "1.3.3"
  namespace	 = "kube-system"

  set {
    name  = "clusterName"
    value = data.aws_eks_cluster.eks_cluster.name
  }

  set {
    name  = "serviceAccount.create"
    value = "false"
  }

  set {
    name  = "serviceAccount.name"
    value = kubernetes_service_account.ingress.metadata[0].name
  }

  set {
      name = "vpcId"
      value = data.aws_eks_cluster.eks_cluster.vpc_config[0].vpc_id
  }

  set {
      name = "region"
      value = var.aws_region
  }

	depends_on = [
		kubernetes_manifest.ingressclass,
		kubernetes_manifest.targetgroupbindings,
		aws_iam_openid_connect_provider.main
	]
}
