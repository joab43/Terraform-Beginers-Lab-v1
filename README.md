# Laboratorio: primeros pasos con Terraform

[![Validación de Terraform](https://github.com/joab43/Terraform-Beginers-Lab-v1/actions/workflows/terraform.yml/badge.svg)](https://github.com/joab43/Terraform-Beginers-Lab-v1/actions/workflows/terraform.yml)

Aprende a declarar recursos, previsualizar cambios y gestionar su ciclo de vida. La configuración **solo administra archivos `.txt` locales**: no necesita una cuenta de nube ni credenciales.

**Duración estimada:** 30–45 minutos. **Requisitos:** [Terraform CLI](https://developer.hashicorp.com/terraform/install) 1.5 o posterior y acceso a Internet para descargar el proveedor `hashicorp/local` durante el primer `init`. Ejecuta todos los comandos desde el directorio que contiene este README. No uses aquí archivos importantes llamados `resumen-<entorno>.txt` o `servicio-<entorno>-<nombre>.txt`: Terraform gestionará esas rutas.

Descarga el laboratorio y entra en su directorio:

```bash
git clone https://github.com/joab43/Terraform-Beginers-Lab-v1.git
cd Terraform-Beginers-Lab-v1
```

## 1. Explora la configuración

| Archivo | Concepto |
| --- | --- |
| `versions.tf` | Versión mínima de Terraform y proveedor requerido. |
| `variables.tf` | Entradas tipadas, valores por defecto y validación. |
| `terraform.tfvars.example` | Valores de ejemplo para personalizar el laboratorio. |
| `main.tf` | Valores locales, recurso `local_file` y múltiples instancias de un módulo con `for_each`. |
| `modulos/servicio/` | Módulo reutilizable que crea la ficha de un servicio. |
| `outputs.tf` | Datos que Terraform muestra después de aplicar. |

Un **recurso** es un objeto que Terraform administra; en este caso, un archivo. Un **proveedor** implementa las operaciones sobre ese objeto. El **estado** (`terraform.tfstate`) registra qué recursos administra Terraform; no lo edites a mano ni lo publiques. Este ejemplo no contiene secretos, pero en proyectos reales el estado puede contenerlos.

## 2. Inicializa y revisa

```bash
terraform version
cp terraform.tfvars.example terraform.tfvars
terraform init
terraform fmt -check -recursive
terraform validate
terraform plan -out=lab.tfplan
```

`init` descarga el proveedor e inicializa el módulo. `fmt -check` revisa el formato y `validate` comprueba la configuración. `plan` compara lo declarado con el estado y guarda una propuesta de cambios en `lab.tfplan`; todavía **no crea archivos**. Inspecciona cuántos recursos propone crear (un resumen y una ficha por servicio).

> `terraform.tfvars` se carga automáticamente. El archivo de ejemplo usa el proyecto `tienda`, el entorno `dev` y los servicios `api` y `web`. Si cambias variables después de guardar el plan, crea un plan nuevo antes de aplicar.

## 3. Aplica e inspecciona

```bash
terraform apply lab.tfplan
terraform output
cat resumen-dev.txt
cat servicio-dev-api.txt
terraform state list
terraform state show 'module.servicios["api"].local_file.ficha'
```

`apply` ejecuta el plan guardado. Observa que `output` muestra las rutas, `state list` enumera los recursos administrados y `state show` presenta los atributos registrados para uno de ellos. Terraform crea también `.terraform/`, `.terraform.lock.hcl` y `terraform.tfstate`. El archivo de bloqueo `.terraform.lock.hcl` fija la selección del proveedor y normalmente se conserva en control de versiones; los demás archivos de trabajo están excluidos en `.gitignore`.

**Pregunta:** ¿qué parte de `main.tf` determina que haya una ficha distinta para `api` y para `web`? ¿Qué diferencia hay entre `var.proyecto` y `local.prefijo`?

## 4. Cambia la configuración

Edita `terraform.tfvars` para que la línea de servicios sea:

```hcl
servicios = ["api", "worker"]
```

Después ejecuta:

```bash
terraform plan
terraform apply
terraform output rutas_servicios
terraform state list
```

Antes de confirmar `apply`, identifica en el plan la ficha de `web` que se elimina, la de `worker` que se crea y el cambio en el resumen. `for_each` identifica cada instancia por el nombre del servicio, no por la posición en la lista.

**Reto opcional:** cambia `proyecto` y vuelve a ejecutar `plan` y `apply`. Comprueba el contenido de los archivos. Prueba también a introducir un nombre inválido, como `"Mi Servicio"`, en `servicios`: la validación de `variables.tf` debe rechazarlo. Restaura un valor válido antes de continuar.

## 5. Limpia

```bash
terraform destroy
terraform state list
```

Confirma el `destroy` después de revisar el plan. Terraform elimina los archivos que creó este laboratorio. `state list` debe quedar vacío; el archivo de estado puede permanecer en el directorio. Puedes borrar `lab.tfplan` y `terraform.tfvars` si ya no los necesitas.

## Resumen de comandos

- `terraform init`: prepara el directorio de trabajo y descarga proveedores.
- `terraform plan`: muestra lo que cambiaría, sin aplicarlo.
- `terraform apply`: crea, actualiza o elimina recursos para alcanzar la configuración deseada.
- `terraform output`: consulta las salidas.
- `terraform state list`: inspecciona las direcciones de los recursos en el estado.
- `terraform destroy`: elimina los recursos administrados por esta configuración.

## Para profundizar o contribuir

Consulta la [guía de conceptos](docs/conceptos.md) para relacionar cada bloque con el funcionamiento de Terraform. Si quieres mejorar el laboratorio, lee [cómo contribuir](CONTRIBUTING.md). GitHub Actions comprueba formato, validación y planificación en cada cambio; el flujo no aplica ni destruye recursos.
