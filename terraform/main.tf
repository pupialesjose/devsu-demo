# Configuración del Provider (Usaremos Kubernetes para ser coherentes con el resto del ejercicio)
terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.0.0"
    }
  }
}

# Definición de variables para mayor flexibilidad (Buenas prácticas)
variable "app_name" {
  description = "Name of the application"
  type        = "string"
  default     = "devsu-app-nodejs"
}

variable "replicas" {
  description = "Number of desired replicas"
  type        = number
  default     = 2
}

# Creación de un Namespace dedicado para la app
resource "kubernetes_namespace" "devsu_ns" {
  metadata {
    name = "devsu-production"
    labels = {
      environment = "production"
      managed_by  = "terraform"
    }
  }
}

# Ejemplo de cómo gestionaríamos un recurso (un LimitRange para control de costos/recursos)
resource "kubernetes_limit_range" "devsu_limits" {
  metadata {
    name      = "${var.app_name}-limits"
    namespace = kubernetes_namespace.devsu_ns.metadata[0].name
  }

  spec {
    limit {
      type = "Container"
      default = {
        cpu    = "500m"
        memory = "512Mi"
      }
      default_request = {
        cpu    = "250m"
        memory = "256Mi"
      }
    }
  }
}

# Output para confirmar la creación
output "namespace_name" {
  value = kubernetes_namespace.devsu_ns.metadata[0].name
}