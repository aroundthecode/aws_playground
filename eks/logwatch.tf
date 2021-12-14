resource "aws_cloudwatch_log_group" "cloudwatch_log_group" {
    name = "/aws/eks/${var.cluster_name}/cluster"
    retention_in_days = 1
    tags = {
        Name   = "${var.cluster_name}-eks-cloudwatch-log-group"
        project = "eks"
    }
}

resource "aws_iam_policy" "AmazonEKSClusterCloudWatchMetricsPolicy" {
  name   = "AmazonEKSClusterCloudWatchMetricsPolicy"
  policy = jsonencode({
    Version: "2012-10-17",
    Statement: [
        {
            Action: [
                "cloudwatch:PutMetricData"
            ],
            Resource: "*",
            Effect: "Allow"
        }
    ]
    })
}

resource "aws_iam_role_policy_attachment" "AmazonEKSCloudWatchMetricsPolicy" {
    policy_arn = aws_iam_policy.AmazonEKSClusterCloudWatchMetricsPolicy.arn
    role       = aws_iam_role.eks_cluster_role.name
}
