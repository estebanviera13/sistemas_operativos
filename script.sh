#!/bin/bash
# Este script es ejecutado por root y crea el usuario SIBAadmin
# Le da los permsos de sudoer para useradd, userdel, usermod
# Carpeta de trabajo : /root/SIBA.
# Copiar este script SIBAinst a /root/SIBA/, y chmod u+x SIBAinst, y ejecutar.
# Decido interfaz

read -p "Desea utilizar interfaz clasica o avanzada ? (c/a) : " icoa

if test -z $icoa; then # si no opto, es clasica

   icoa=c

fi


#echo $icoa


#exit


# Bienvenida
msg='Bienvenido a la instalacion de SIAD !'

if test $icoa == "c"; then

   read -p "$msg"

else

   dialog --msgbox "$msg" 5 43

fi





# Creo usuario SIADadmin, su shell es SIADmenu (ejecuta en login)

# SIADadmin debe tener home por el tema logs (/home/SIADadmin/log) y por su bin.

useradd -d /home/SIADadmin -m -s /home/SIADadmin/bin/SIADmenu -c "Administrador de SIAD" SIADadmin 2>/dev/null

res=$(echo $?)

if test $res -eq 9; then

  msj='SIADadmin ya existia en el sistema y sera eliminado'

  if test $icoa == "c"; then 

    read  -p "$msj"

  else

    dialog --msgbox "$msj" 7 43

  fi

  userdel -r SIADadmin

  useradd -d /home/SIADadmin -m -s /home/SIADadmin/bin/SIADmenu -c "Administrador de SIAD" SIADadmin 2>/dev/null

fi

msg='SIBAadmin fue creado con exito!'

if test $icoa == "c"; then 

    read  -p "$msg"

else

    dialog --msgbox "$msg" 5 43

fi



#exit



# Area contraseña

msg='SIADadmin - Por favor,Ingrese su nueva contraseña :'

msgV='SIADadmin - Por favor, re ingrese su nueva contraseña :'

msgPwdOk='Su clave se ha ingresado con exito'

msgPwdErr='Las claves no coinciden, vuelva a intentarlo'

while true; do

  if test $icoa == "c"; then

    read -s -p "$msg" contr # -s : hace que no se vea en pantalla

    echo

    read -s -p "$msgV" nuevacontr

    echo

    if [ "$contr" == "$nuevacontr" ]; then

      if test -z "$contr"; then

        read -p "contrasena vacia" x

        continue

      fi

      read -p "$msgPwdOk"

      break

    else

      read -p "$msgPwdErr"

    fi

  else

    dialog --insecure --mixedform '* Formulario de ingreso de clave *' 17 45 7 \

    'Clave :' 2 5 '' 2 19 15 20 1 \

    'Repita Clave :' 4 5 '' 4 19 15 20 1 2>sd

    contr=$(head -1 sd)

    nuevacontr=$(tail -1 sd)

    if [ "$contr" == "$nuevacontr" ]; then

      if test -z "$contr"; then

        dialog --msgbox "clave vacia" 7 43

        continue

      fi

      dialog --msgbox "$msgPwdOk" 7 43

      break

    else

      dialog --msgbox "$msgPwdErr" 7 43

    fi

  fi # if test $icoa == "c"; then

done

echo SIBAadmin:$contr | chpasswd





echo

ver='Insertando permisos ABM para usuario & grupo..!'

if test $icoa == "c"; then 

    read  -p "$ver"

else

    dialog --msgbox "$ver" 6 43

fi

# entradas de /etc/sudoers para SIBAadmin

grep 'Comienzo permisos del subsistema SIAD' /etc/sudoers

if test $? -eq 1; then

  echo >>/etc/sudoers

  echo '#' >>/etc/sudoers

  echo '# Comienzo permisos del subsistema SIAD' >>/etc/sudoers

  echo 'SIADadmin '$HOSTNAME' = (ALL) NOPASSWD: '$(which useradd) >>/etc/sudoers

  echo 'SIADadmin '$HOSTNAME' = (ALL) NOPASSWD: '$(which userdel) >>/etc/sudoers

  echo 'SIADadmin '$HOSTNAME' = (ALL) NOPASSWD: '$(which usermod) >>/etc/sudoers

  echo 'SIADadmin '$HOSTNAME' = (ALL) NOPASSWD: '$(which groupadd) >>/etc/sudoers

  echo 'SIADadmin '$HOSTNAME' = (ALL) NOPASSWD: '$(which groupdel) >>/etc/sudoers

  echo 'SIADadmin '$HOSTNAME' = (ALL) NOPASSWD: '$(which groupmod) >>/etc/sudoers

  echo 'SIADadmin '$HOSTNAME' = (ALL) NOPASSWD: /usr/bin/passwd SIAD*' >>/etc/sudoers

fi



exit



echo

# copiar SIADmenu al home de SIADadmin y darle la propiedad mediante chown

ver='Copiando SIADMenu al home de SIADadmin y entregandole permiso de usuario dueño...'

if test $icoa == "c"; then 

    read  -p "$ver"

else

    dialog --msgbox "$ver" 7 43

fi



# creo directorio de bin

mkdir /home/SIADadmin/bin

echo

ver='Creado el directorio bin a SIADadmin...'

if test $icoa == "c"; then 

    read  -p "$ver"

else

    dialog --msgbox "$ver" 7 43

fi



# le doy la propiedad de la carpeta a SIBAadmin

chown SIADadmin:SIADadmin /home/SIADadmin/bin

echo

ver='Entregada la propiedad de la carpeta a SIADadmin...'

if test $icoa == "c"; then 

    read  -p "$ver"

else

    dialog --msgbox "$ver" 7 43

fi



# copio SIADmenu

cp /root/SIAD/SIADmenu /home/SIADadmin/bin

echo

ver='Copiado SIADmenu al directorio bin...'

if test $icoa == "c"; then 

    read  -p "$ver"

else

    dialog --msgbox "$ver" 6 43

fi



# le doy la propiedad del script a SIBAadmin

chown SIADadmin:SIADadmin /home/SIADadmin/bin/SIADmenu

ver='Transladados permisos de usuario dueño de SIADmenu...'

if test $icoa == "c"; then 

    read  -p "$ver"

else

    dialog --msgbox "$ver" 7 43

fi



# le doy permisos de ejecucion al propietario

echo

chmod u+x /home/SIADadmin/bin/SIADmenu

ver='Asignando permiso de ejecucion al dueño..'

if test $icoa == "c"; then 

    read  -p "$ver"

else

    dialog --msgbox "$ver" 7 43

fi
