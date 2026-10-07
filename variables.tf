variable "proyecto" {
  description = "Nombre del proyecto que aparecerá en los archivos generados."
  type        = string
  default     = "mi-primer-lab"
}

variable "entorno" {
  description = "Entorno del laboratorio (se usa en los nombres de archivo)."
  type        = string
  default     = "dev"

  validation {
    condition     = can(regex("^[a-z][a-z0-9-]*$", var.entorno))
    error_message = "entorno debe comenzar por una letra minúscula y contener solo letras minúsculas, números o guiones."
  }
}

variable "servicios" {
  description = "Nombres de los servicios para los que se generará una ficha."
  type        = set(string)
  default     = ["api", "web"]

  validation {
    condition     = length(var.servicios) > 0 && alltrue([for servicio in var.servicios : can(regex("^[a-z][a-z0-9-]*$", servicio))])
    error_message = "servicios debe contener al menos un nombre; cada nombre debe comenzar por una letra minúscula y usar solo letras minúsculas, números o guiones."
  }
}
