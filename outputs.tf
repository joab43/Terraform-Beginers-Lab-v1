output "ruta_resumen" {
  description = "Ruta del archivo con el resumen del laboratorio."
  value       = local_file.resumen.filename
}

output "rutas_servicios" {
  description = "Ruta de la ficha de cada servicio."
  value       = { for nombre, servicio in module.servicios : nombre => servicio.ruta }
}
