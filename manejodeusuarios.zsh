# ya que este projecto era para ayudar a una empresa fictisia llamada GreenCorp cree las diferentes carpetas basado en eso, cada usuario lo puede modificar a su gusto 
# este archivo combina otros pero el main es el de manejodeusuarios.zsh ya que los otros se pueden ver mas como clases ayudantes para cuadrar el sistema 

# 
#!/bin/zsh
# ayudante1.zsh

# lista de roles y creando carpetas
roles=("usuario_generico" "admin_it" "gerente")
sudo mkdir -p /home/GreenCorp

# creando diferentes carpetas basadas en rol de manera recursiva con un loop 
for role in $roles; do
  sudo mkdir -p "/home/GreenCorp/$role"
done

#DESDE ACA EMPIEZA LA IMPORTANTE 
#!/bin/zsh
# manejodeusuarios.zsh

#generando paths para las carpetas y creando las necesarias que despues utilizar para testear 
base_dir="/home/GreenCorp"
fake_users="$base_dir/fake_users"
sudo mkdir -p "$fake_users"

# creando una lista asociativa (funciona como un diccionario) 
declare -A usuarios=(
  [usuario_generico]=usuarios_genericos
  [admin_it]=administradores_it
  [gerente]=gerentes
)

# basado en el grupo y rol de el usuario reciben diferentes permisos a archivos
asignar_permisos() {
  local archivo="$1" #'local' por el scope de las variables
  local rol="$2"
  case "$rol" in
#basado en que tipo de rol tienen sus correspondientes permisos r,w,x
    usuario_generico) sudo chmod 400 "$archivo" ;;
    admin_it)         sudo chmod 750 "$archivo" ;;
    gerente)          sudo chmod 777 "$archivo" ;;
    *)                sudo chmod 644 "$archivo" ;;
  esac
}

# para crear un usuario en el sistema 
crear_usuario() {
  local nombre="$1"
  local rol="$2"
  local grupo="${usuarios[$rol]}"
# crea un directorio para poner los usuarions en diferentes grupos basados en sus roles 
  sudo mkdir -p "$base_dir/$grupo"

# una series de comando usando piping "|"
  echo "username: $nombre" | sudo tee "$fake_users/$nombre.user"  # escribe el nombre de el usuario en fake_users (q funciona como mi database) 
  echo "role: $rol" | sudo tee -a "$fake_users/$nombre.user" # mete el rol a el usuario correcto
  sudo cp "$fake_users/$nombre.user" "$base_dir/$grupo/" #mete a la persona a el grupo que es 

#llamando la ptra clase con los argumentos necesarios 
  asignar_permisos "$fake_users/$nombre.user" "$rol"
  asignar_permisos "$base_dir/$grupo/$nombre.user" "$rol"
  echo "usuario '$nombre' creado con rol '$rol'."
}

# para cambiar el usuario ya sea su nombre o rol
modificar_usuario() {
#variables locales para guardar los cambios
  local viejo="$1"
  local nuevo="$2"
  local archivo="$fake_users/$viejo.user"
  local rol=$(grep "role:" "$archivo" | cut -d' ' -f2) #agarra el rol de la persona usando algo ismilar a splice 
  local grupo="${usuarios[$rol]}"
  sudo mv "$archivo" "$fake_users/$nuevo.user"
  sudo sed -i "" "s/username: .*/username: $nuevo/" "$fake_users/$nuevo.user" #hace un inplace cambio y actualiza el usuario
  sudo mv "$base_dir/$grupo/$viejo.user" "$base_dir/$grupo/$nuevo.user" 

#llama la funcion y cambia los permisos 
  asignar_permisos "$fake_users/$nuevo.user" "$rol"
  asignar_permisos "$base_dir/$grupo/$nuevo.user" "$rol"
  echo "usuario renombrado de '$viejo' a '$nuevo'"
}


#funcion para eliminar un usario
eliminar_usuario() {
  local nombre="$1"
  local archivo="$fake_users/$nombre.user"
  local rol=$(grep "role:" "$archivo" | cut -d' ' -f2) #busca el usario y similar a la funcion anterior usa solice para agarrar la segunda parte
  local grupo="${usuarios[$rol]}"
# eliminando datos de el usuario 
  sudo rm -f "$archivo"
  sudo rm -f "$base_dir/$grupo/$nombre.user"
  echo "usuario '$nombre' eliminado."
}

#para cambiar el rol de un usuario 
reasignar_rol() {
  local nombre="$1"
  local nuevo_rol="$2"
  local nuevo_grupo="${usuarios[$nuevo_rol]}"
  local archivo="$fake_users/$nombre.user"
  local viejo_rol=$(grep "role:" "$archivo" | cut -d' ' -f2) #similar a lo de arriba
  local viejo_grupo="${usuarios[$viejo_rol]}"
  sudo sed -i "" "s/role: .*/role: $nuevo_rol/" "$archivo" #note que esta notacion de sed -i es epcaial para mac y creo que en linux es diferente
  sudo mv "$base_dir/$viejo_grupo/$nombre.user" "$base_dir/$nuevo_grupo/$nombre.user"
#llama funcion y cambia los permisos 
  asignar_permisos "$archivo" "$nuevo_rol"
  asignar_permisos "$base_dir/$nuevo_grupo/$nombre.user" "$nuevo_rol"
  echo "usuario '$nombre' reasignado a rol '$nuevo_rol'"
}

#basado en la palabra usada ejecuta el metodo entonces por ejemplo ./manejodeusuarios.zsh create juan gerente va a crear un nuevo usuario llamadao juan que es un gerente 
case "$1" in
  create)  crear_usuario "$2" "$3" ;;
  modify)  modificar_usuario "$2" "$3" ;;
  delete)  eliminar_usuario "$2" ;;
  assign)  reasignar_rol "$2" "$3" ;;
  *)  ;
esac



# el fin :) 
