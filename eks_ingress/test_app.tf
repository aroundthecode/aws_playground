



resource "kubernetes_namespace" "fargate" {
  metadata {
    labels = {
      app = "fargate-app"
    }
    name = var.fargate_namespace
  }

  depends_on = [ helm_release.alb-ingress-controller ]
}

resource "kubernetes_deployment" "app" {
  metadata {
    name      = "nginx-server"
    namespace = var.fargate_namespace
    labels    = {
      app = "nginx"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "nginx"
      }
    }

    template {
      metadata {
        labels = {
          app = "nginx"
        }
      }

      spec {
        container {
          image = "nginx"
          name  = "nginx-server"

          port {
            container_port = 80
          }
        }
      }
    }
  }
   depends_on = [kubernetes_namespace.fargate]

}


resource "kubernetes_service" "network-load-balancer" {
  metadata {
    name      = "nginx-service"
    namespace = var.fargate_namespace
    annotations = {
      #service.beta.kubernetes.io/aws-load-balancer-type: nlb-ip
      "service.beta.kubernetes.io/aws-load-balancer-type": "external"
      "service.beta.kubernetes.io/aws-load-balancer-nlb-target-type": "ip"
      
    }
  }
  spec {
    selector = {
      app = "nginx"
    }

    port {
      port        = 80
      target_port = 80
      protocol    = "TCP"
    }

    type = "LoadBalancer"
  }

  depends_on = [kubernetes_deployment.app]
}

resource "kubernetes_ingress" "app" {
  metadata {
    name      = "nginx-lb"
    namespace = var.fargate_namespace
    annotations = {
      "kubernetes.io/ingress.class"           = "alb"
      "alb.ingress.kubernetes.io/scheme"      = "internet-facing"
      "alb.ingress.kubernetes.io/target-type" = "ip"
    }
    labels = {
        "app" = "nginx"
    }
  }

  spec {
      backend {
        service_name = "nginx-service"
        service_port = 80
      }
    rule {
      http {
        path {
          path = "/"
          backend {
            service_name = "nginx-service"
            service_port = 80
          }
        }
      }
    }
  }

  depends_on = [kubernetes_service.network-load-balancer]
}