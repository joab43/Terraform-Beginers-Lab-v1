# Cómo contribuir

¡Gracias por mejorar este laboratorio! La documentación y los ejemplos están en español y están dirigidos a quienes empiezan con Terraform.

## Antes de proponer cambios

1. Instala Terraform 1.5 o posterior.
2. Crea una rama para tus cambios.
3. Ejecuta desde la raíz del repositorio:

   ```bash
   terraform init -backend=false
   terraform fmt -check -recursive
   terraform validate
   terraform plan
   ```

4. Si ejecutaste `terraform apply`, termina con `terraform destroy` antes de dar por concluida la prueba.
5. Abre un pull request que explique qué cambiaste y cómo lo verificaste. GitHub Actions comprueba automáticamente formato, inicialización, validación y plan.

No incluyas archivos de estado, planes, `terraform.tfvars` reales, credenciales ni archivos `.txt` generados. Conserva `.terraform.lock.hcl` en el repositorio para reproducir la selección del proveedor. Si actualizas el proveedor, explica el motivo y revisa el cambio del archivo de bloqueo.
