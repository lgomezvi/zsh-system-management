#!/bin/zsh
# limpiezadearchivosylogs.zsh

# simplemente para saber en el terminal que si esta corriendo 
echo "Empieza la limpieza"

# revisa los directorios mas comunes con archivos temporales y logs 
for dir in /tmp /var/log /var/tmp; do
  if [ -d "$dir" ]; then #revisa si si existe el directorio
    sudo find "$dir" -type f -mtime +7 -exec rm -f {} \; # busca y elimina (en este caso basado en los que tengan mas de 7 dias en el sistema)
  fi
done

echo "Limpieza completada."
