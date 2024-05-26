# Odoo-Docker-Produccion
Template Odoo con docker & docker compose  v16 community

## Desarrollado por: 
	- "Elias Braceras" 
	- "Horacio Montaño" 
	-  Repo: [https://github.com/HDM-soft/odoo16-prod]

## Breve Descripcion :

Este repositorio tiene como funcion servir como base para implementaciones productivas. 
El mismo esta compuesto por los archivos necesarios para el despliegue de una instancia de Odoo con Docker,
Docker Compose y la herramienta GITMAN

### Archivos Necesarios

* Directorio "addons"
* Directorio "config/odoo.conf"
* Archivo "odoo_pg_pass"
* Archivo "**Dockerfile**"
* Archivo "**docker-compose.yml**"
* Archivo "**gitman.yml**"
* Archivo "**install_dependencies.sh**"

_ Este template fue desarrollado para agilizar los despliegues en produccion y de test, usando herramientas 
que facilitan la tarea como es la herramienta Docker y Docker Compose. La cual nos permite en pocos pasos y 
con pocos comandos poner en marcha nuestro sistema de gestion ERP-ODOO; habiendo determinado previamente 
en nuestro archivo *docker-compose.yml* los servicios que deseamos correr, como lo son Odoo y su version y 
Postgres con su version. Disponemos de un archivo constructor de nuestra imagen propia *Dockerfile*
donde predefinimos la version de Odoo como primera medida y las carpetas y archivos que necesitamos 
disponer dentro de nuestro contenedor una vez inciado. Asi como tambien el comando que se debe 
ejecutar una vez inciado el despiegue. 

_ Este directorio completo cuenta con la herramienta *gitman*

> Gitman es un gestor de dependencias agnóstico del lenguaje que utiliza Git. 
> Su objetivo es servir como sustituto de submódulos y proporciona opciones avanzadas 
> para gestionar versiones de repositorios Git anidados.

Dicha herramienta nos facilita determinar como submodulos todos los addons y paquetes de addons que necesitemos utilizar de terceros.
Para esto los mismos deben ser de caracter publico y con esta herramienta cada cambio necesario o actualizacion de 
estos, es viable con tan solo dos comandos. 
*Si desea aprender mas sobre GITMAN* les compartimos el link oficial de su documentacion:
_ [https://gitman.readthedocs.io/en/latest/]

_ Ademas esta disponible la carpeta **addons** en la cual podremos colocar cualquier modulo de tercero como los propios desarrollados.

-------------------------------------------------------------------------------------------------------------------------------------

## Consideraciones para comenzar:

_ Es importante tener en cuenta que el **Dockerfile** tiene predeterminada la version 16.0 cc
no obstante usted puede modificar el mismo y setear la primer linea de codigo del Dockerfile 
```
FROM odoo:16.0
```
por la version a eleccion.

_ Todo cambio realizado en su **odoo.conf** como la version y nombre del contenedor de la base de datos, como su **admin_passwd**
y su **addons_path**, sera necesario que una vez realizado el cambio realice un nuevo build de su imagen, manteniendo y 
respetando el nombre de su imagen creada por primera vez, para asi no perder los cambios ya realizados y manteniendo
el nombre de sus contenedores  web y db dentro de su **docker-compose.yml** 
*Esto lo comprendera en los siguientes pasos*

_ El archivo "**odoo.conf**" debe tener los siguentes claves valor necesarios y que deben respetar lo declarado en el 
"**docker-compose.yml**"
	_ addons_path = (se debe declarar el directorio addons y cada uno de los directorios declarados en el GITMAN)
	_ db_host = "debe ser el mismo declarado en el docker-compose"
	_ db_port = 5432
	_ db_user = odoo
	_ db_password = odoo (esta corresponde a la passwd guardada en odoo_pg_pass)

------------------------------------------------------------------------------------------------------------------------------------

## ¿Como utilizar GITMAN? 

_ Gitman nos permite cargar los modulos de terceros y paquetes completos o algunos de los modulos contenidos en 
cada paquete como los son "**account-financial-tools** que como bien sabemos es un repositorio que contiene
una variedad de addons en su interior. 
A continuacion mostraremos la utilidad de cada linea de gitman. 

	_ location: external_addons 

Esta linea determina como se llamara la carpeta donde se alojaran e instalan  los modulos declarados en gitman
este directorio se autocreara durante el proceso de construccion de la imagen con el *Dockerfile*

	_ sources:
	   _ repo: https://github.com/oca/oca_maintenance.git

En esta linea se debe colocar el repositorio publico que desamos instalar como submodulo dentro de nuestra instancia. 

	_ name: oca_maintenance

Sirve para colocar el nombre, de la forma que queremos que dentro de nuestra carpeta "*external_addons*" lleve por nombre

	_ rev: 16.0

En esta linea debemos colocar la rama del repositorio que necesitamos descargar

	_ type: git 

Tipo de repositorio GIT 

	_ params: 

Arguemento adicional 

	_ sparse_paths: 
	  _ ""

Esta linea es de utilidad si deseamos colocar algunos modulos contenidos dentro del repositorio y no el repositorio completo

	_ scripts:
	  _ sh /usr/lib/puthon3/dist-packages/odoo/install_dependecies.sh

En esta linea determinamos la ejecucion  del archivo que se encargara de instalar las dependencias contenidas en los modulos con el 
nombre "**requirements.txt**" Este archivo sera copiado durante el proceso de construccion del "Dockerfile" 

----------------------------------------------------------------------------------------------------------------------------------

## PASOS: 

1. Clonar o descargar  el repositorio "**odoo16-prod**" en su maquina local 
2. Revisar a gusto la version de Odoo que desea usar dentro del DOCKERFILE en la primer linea FROM
3. Editar el archivo **docker-compose.yml** segun su necesidad, determinando un nombre de imagen 
nombre de contenedor, puerto de Odoo, los volumens, el campo HOST en "environment" de servicio web, el nombre de imagen del 
servicio DB, nombre del contenedor db. 
4. Recuerde de modificar el archivo "**odoo.conf**" respetando el db_host con el nombre de contenedor db declarado en el 
"**docker-compose.yml**" como tambien respetar el usuario y contraseña de la db que desea usar. 
5. Editar su archivo "**gitman.yml**" con los repositorios que desea usar. 
> Para este repositorio se declararon los repos disponibles por ADHOC para la localizacion argentina como asi tambien ,
> el modulo "account_accountant" de Odoo Mates para la contabilidad completa. 
> Sientase libre de modificar a gusto. 
6. Todos los repositorios declarados en el "gitman" seran necesarios declarar en el archivo "odoo.conf" dentro de la 
linea "**addons_paths**" 
Ejemplo : 
	_ addons_path: usr/lib/python/dist-packages/odoo/extra_addons/,usr/lib/python/dist-packages/odoo/external_addons/odooapps

Todos los paths deberan estar separados por una coma "," 
En este ejemplo se muestra primero, declarado el path de la carpeta "**addons**" y luego los que se declaran en gitman 
dentro de la carpeta "**external_addons**" 

7. ¡ TODO LISTO PARA INICIAR LA CONSTRUCCION DE LA IMAGEN !
8. Ejecutar el comando para construir la imagen 
	- ``` sudo docker build . -t nombre-de-mi-imagen ``` 

Comenzara la construccion de su imagen docker con el nombre que desee, recuerde que ese nombre de imagen es el que 
debe utilizar en su archivo "**docker-compose.yml**" No importa si aun no lo edito, puede hacerlo luego de la 
construccion. 

9. Durante el proceso de construccion, docker build se encargarar de leer las lineas y copiar los directorios
necesarios de odoo dentro del contenedor web y a su vez, realizara la creacion de la carpeta "**external_addons**" 
como la instalacion de los addons y paquetes declarados en "**gitman.yml**" y la ejecucion de los "**requirements.txt**"

10. Luego de la construccion satisfactoria ahora debe verificar su "**docker-compose.yml**" y asegurarse que 
los datos estan correctos, con respecto a nombre de imagen y volumens declarados para los modulos como tambien 
los declarados en el "**odoo.conf**" 
11. Ejecutar el comando : 
	- ``` sudo docker compose up -d ``` 
Con este comando usted levantara los servicios de odoo y postgresql, una vez ejecutado y finalizado puede 
verificar si esta corriendo con el comando : 
	- ``` sudo docker compose ps ``
12. Su sistema odoo esta corriendo, y ahora puede consultarlo en su navegador web con la url o ip publica o localhost
dependiendo donde esta corriendo su sistema de gestion y crear su primer base de datos. 

----------------------------------------------------------------------------------------------------------------------------------

## ¿Como hacer cambios de configuracion? 

Es de vital importancia saber que para no perder la informacion de la base de datos, si desea realizar cambios como: 
actualizar los repositorios de gitman o agregar nuevos modulos en la carpeta addons, como tambien si desea realizar 
algun cambio de configuracion en su **odoo.conf** todos y cada uno de estos sera necesario realizar un re-build 
de su imagen. 
Para esto debe tener en cuenta de una vez realizado estos cambios y guardados sera importante que realice un stop 
en sus contenedores con el comando ``` sudo docker compose stop `` SOLO STOP , ya que si usa el comando *down* o 
*down -v* perdera todos los cambios en su base de datos. 

Una vez detenedio debera realizar un build nuevamente manteniendo el nombre de la imagen que esta usando. 
Si no recuerda el nombre de su imagen lo puede consultar con el comando ``` sudo docker image ls ``
Si no usa el mismo nombre de imagen, tambien perdera los cambios. 
Para hacer un rebuild use el comando
	- ``` sudo docker build . -t nombre-de-mi-imagen ``
Una ves finalizada la reconstruccion de su imagen puede levantar nuevamente los contenedores con el comando 
	- ``` sudo docker compose up -d ``
Ingresar en su instancia con su navegador web de preferencia y de esta manera no sufrira ninguna perdida de informacion
Tambien puede realizar el re-build sin necesaridad de para el contenedor con el comando "docker compose stop" y una 
vez realizados los cambios deseados, puede usar el comando 
	- ``` sudo docker compose restart ``
Y seria sufieciente para poder obtener los cambios deseados, como lo son agregar nuevos addons. Pero es importante
mencionar que no siempre los toma a los cambios con un "restart", asi de esta manera usted debera detener los 
contenedores y hacer el re-build para luego levantar los contenedores. 


----------------------------------------------------------------------------------------------------------------------------------

## Soporte Tecnico 

_ Si usted tiene alguna duda sobre el funcionamiento de este ambiente de produccion puede contactarse y enviarnos un ticket 
de soporte al siguiente link: 
	- [https://hdmsoft.com.ar/contact]
 


 
