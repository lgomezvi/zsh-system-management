# zsh-system-management
Project made to better develop my scripting skills in my operating systems class (its in spanish as I took this course on my abroad semester) 

Scripts de Administración del Sistema en Zsh

Este repositorio contiene una colección de scripts escritos en Zsh para automatizar tareas básicas de mantenimiento del sistema en entornos tipo Unix. Están diseñados para funcionar en cualquier sistema real, haciendo uso de rutas absolutas, permisos adecuados y `sudo` donde sea necesario.

Scripts Incluidos
## `limpiezadearchivosylogs.zsh`
Limpia archivos temporales y logs con más de 7 días de antigüedad en directorios comunes del sistema (`/tmp`, `/var/log`, `/var/tmp`). Utiliza `sudo` para asegurar permisos adecuados.

### `respaldodearchivos.zsh`
Copia el contenido de `~/Documents` a un directorio de respaldo oculto con timestamp, asegurando que los respaldos se mantengan organizados.

## `manejodeusuarios.zsh`
Gestiona usuarios simulados mediante archivos con permisos personalizados según el rol. Utiliza `/home/GreenCorp/fake_users` y requiere `sudo`.

## Ejemplo de Uso
```zsh
zsh limpiezadearchivosylogs.zsh
zsh respaldodearchivos.zsh
zsh setup_user_dirs.zsh
zsh manejodeusuarios.zsh create maria gerente
zsh manejodeusuarios.zsh modify maria mariana
zsh manejodeusuarios.zsh assign mariana admin_it
zsh manejodeusuarios.zsh delete mariana
```
## Requisitos

* Shell: Zsh
* Permisos de administrador (`sudo`)
* Entorno Unix/Linux con acceso a `/home`, `/tmp`, `/var/log`, etc.

## 📂 Estructura de Carpetas (note; esa carpeta fue especialmemte creada para simular esto pero se podria utilizar para un sistema real si la base de datos fuera dada) 
/home/GreenCorp/
├── administradores_it/
├── gerentes/
├── usuarios_genericos/
├── fake_users/
└── ...
```

