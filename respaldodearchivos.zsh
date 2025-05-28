#!/bin/zsh
# respaldodearchivos.zsh

# crea un path para la direccion donde se van a guardar los respaldados 
respaldo_dir="$HOME/.respaldos/$(date +%Y-%m-%d_%H-%M)" #note lo decidi hacer .oculto por mas seguridad

# crea un directorio padre 
sudo mkdir -p "$respaldo_dir"

#loop travesando los documentos para ser respaldados 
for file in "$HOME/Documents"/*; do
  sudo cp -r "$file" "$respaldo_dir/" #los copia recursivamente y copia a el directorio de respalo 
  echo "Respaldado: $file"
done

echo "Respaldo completado, guardado en: $respaldo_dir"
