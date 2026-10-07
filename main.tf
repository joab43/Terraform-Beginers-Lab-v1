locals {
  directorio = abspath(path.root)
  prefijo    = "${var.proyecto} (${var.entorno})"
}

resource "local_file" "resumen" {
  filename        = "${local.directorio}/resumen-${var.entorno}.txt"
  file_permission = "0644"
  content         = <<-EOT
    Proyecto: ${local.prefijo}
    Servicios: ${join(", ", sort(tolist(var.servicios)))}
  EOT
}

module "servicios" {
  source   = "./modulos/servicio"
  for_each = var.servicios

  nombre       = each.value
  proyecto     = var.proyecto
  entorno      = var.entorno
  ruta_archivo = "${local.directorio}/servicio-${var.entorno}-${each.value}.txt"
}
