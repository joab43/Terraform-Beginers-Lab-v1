resource "local_file" "ficha" {
  filename        = var.ruta_archivo
  file_permission = "0644"
  content         = <<-EOT
    Servicio: ${var.nombre}
    Proyecto: ${var.proyecto}
    Entorno: ${var.entorno}
  EOT
}
