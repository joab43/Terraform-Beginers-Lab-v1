# Guía breve de conceptos

Este laboratorio usa el proveedor `hashicorp/local`. Terraform no provisiona servidores: administra un archivo de resumen y una ficha por servicio en tu propio equipo.

## Del código a los archivos

1. **Configuración:** los archivos `.tf` describen el resultado deseado en HCL.
2. **Inicialización (`terraform init`):** Terraform instala el proveedor declarado en `versions.tf` y lee el módulo local `modulos/servicio/`.
3. **Planificación (`terraform plan`):** compara configuración, estado y archivos existentes para proponer acciones. No las ejecuta.
4. **Aplicación (`terraform apply`):** ejecuta las acciones aprobadas y actualiza el estado.
5. **Destrucción (`terraform destroy`):** elimina los recursos administrados. Revisa el plan antes de confirmarlo.

## ¿Dónde aparece cada concepto?

| Concepto | Ejemplo en este repositorio |
| --- | --- |
| Proveedor | `hashicorp/local` en `versions.tf`; permite gestionar archivos. |
| Variable | `var.proyecto`, `var.entorno` y `var.servicios` en `variables.tf`. Sus valores pueden venir de `terraform.tfvars`. |
| Valor local | `local.directorio` y `local.prefijo` en `main.tf`; calculan expresiones dentro de la configuración. |
| Recurso | `local_file.resumen` en `main.tf` y `local_file.ficha` dentro del módulo. |
| Módulo | `modulos/servicio/` encapsula cómo crear una ficha y expone su ruta. |
| `for_each` | `module.servicios` crea una instancia por nombre de servicio; cada instancia mantiene una dirección estable como `module.servicios["api"]`. |
| Salida | `ruta_resumen` y `rutas_servicios` en `outputs.tf`; permiten consultar los resultados. |
| Estado | `terraform.tfstate` registra las direcciones y atributos administrados. No es la configuración fuente. |
| Archivo de bloqueo | `.terraform.lock.hcl` fija la versión y las sumas de verificación del proveedor descargado. |

## Experimenta de forma segura

- Cambia `servicios` de `["api", "web"]` a `["api", "worker"]` y consulta el plan: la ficha de `api` se conserva, la de `web` se destruye y se crea la de `worker`. El resumen se reemplaza porque su contenido cambia.
- Edita manualmente uno de los `.txt` generados y ejecuta `terraform plan`: Terraform puede detectar la diferencia y proponer recrear ese archivo. Esto se conoce como **deriva** respecto a lo declarado.
- Ejecuta `terraform output` para ver rutas y `terraform state list` para consultar las direcciones de los recursos.

**Importante:** en proyectos reales, el estado y los archivos de plan pueden contener datos sensibles. Están excluidos por `.gitignore`; no los publiques ni agregues secretos a este ejemplo. El proveedor local trabaja sobre tu equipo, por lo que no debes ejecutar este laboratorio sobre archivos que quieras conservar.

Vuelve al [laboratorio guiado](../README.md).
