**ACTUALIZADO 2017 ARCHLINUX
**
OJO: xxx.xxx.xxx.xxx es igual a tu ip publica.

sudo useradd csserver

sudo passwd csserver

sudo mkdir /home/csserver

sudo chown csserver /home/csserver

su - csserver

wget "https://downloads.sourceforge.net/project/cs16serverpreconfiguredlinux/beta2014/linuxserver%2BdprotoDualnosteam.tar.gz"

tar xvzf linuxserver+dprotoDualnosteam.tar.gz

cd /home/csserver/27020

./hlds_run -game cstrike +ip xxx.xxx.xxx.xxx +port 27016 -pingboost 3 +maxplayers 22 +map de_dust -autoupdate

SERVER EN SEGUNDO PLANO

screen -A -m -d -S csserver ./hlds_run -game cstrike +ip xxx.xxx.xxx.xxx +port 27016 -pingboost 3 +maxplayers 22 +map de_dust -autoupdate &

server counter-strike 1.6 linux -ubuntu-ARCH 2017

CREAR SERVICIO EN EL SISTEMA:

sudo nano /etc/systemd/system/hlds.service

[Unit]
Description=HLDS
Wants=network-online.target
After=network-online.target

[Service]
WorkingDirectory=/home/csserver/27020
ExecStart=/home/csserver/27020/hlds_run -game cstrike +ip XXX.XXX.XXX +port 27016 -pingboost 3 +maxplayers 22 +map de_dust -autoupdate
User=hlds
Restart=on-failure

[Install]
WantedBy=multi-user.target

sudo systemctl daemon-reload

sudo systemctl enable hlds

sudo systemctl start hlds

<hr>
INSTALACIÓN DE SERVER CS 1.6 LINUX(Testeado Ubuntu 13.10 & 14.04 x64)
Actualmente el HLDSUpdateTool.bin fue sustituido por STEAMCMD, que hace exactamente lo mismo que el anterior, pero generando
Cierta confusión por que no existen manuales confiables, en las referencias encontras un script que se supone instala el servidor, este
me ha generado 2 problemas, Instalación corrupta y alto ping de cualquier forma lo anexo ya que sirvió de base para esta guía.

Esta dirigida a usuarios con conocimientos básicos de Linux, pero eso no exenta conocimientos de apertura de puertos en router/modem ,
así como de administración ssh,ftp, es importante que abras los puertos que vas utilizar 27005 y 27016 necesarios para esta guía tanto en
el sistema como en el router/modem.

te recomiendo , utilizar la última versión de Ubuntu hoy en día 14.04 en su versión de servidor

http://www.ubuntu.com/download

Y tener unos buenos repositorios en tu /etc/apt/sources.list

http://repogen.simplylinux.ch/

Mantener actualizado nuestro sistema antes de instalar

sudo apt-get update && apt-get upgrade

Contenido

linuxserver+dprotoDualnosteam.tar.gz : Contiene los archivos configurados para servidor dedicado counter-strike 1.6, con metamod y amxmodx configurados para trabajar sobre el directorio

/home/csserver/27020

El archivo liblist.gam, ya esta debidamente configurado perfectamente no es necesario modificarlo

gamedll "addons/metamod/dlls/metamod.dll"
gamedll_linux "addons/metamod/dlls/metamod.so"
gamedll_osx "addons/metamod/dlls/metamod.dylib"

INCIO DE INSTALACION
Pre Requisitos (No puedes continuar si no los cumples sobretodo las librerías gcc)

Dependencias (Si tu sistema es x86 salta la primer línea)

dpkg --add-architecture i386
apt-get update
apt-get install gdb mailutils postfix tmux ca-certificates lib32gcc1

sudo apt-get install gcc g++ clang
sudo apt-get install lib32z1 lib32ncurses5 lib32bz2-1.0
sudo apt-get install lib32z1 lib32z1-dev
sudo apt-get install libc6-dev-i386 libc6-i386
sudo apt-get install gcc-multilib g++-multilib

adduser csserver
passwd csserver
su - csserver

cd /home/csserver

DESCARGAR EL ARCHIVO
(wget linuxserver+dprotoDualnosteam.tar.gz)

wget http://softlayer-dal.dl.sourceforge.net/project/cs16serverpreconfiguredlinux/beta2014/linuxserver%2BdprotoDualnosteam.tar.gz

tar xvzf linuxserver+dprotoDualnosteam.tar.gz

cd 27020/cstrike

modificar el archivo server.cfg

nano server.cfg
O
vim server.cfg

modificar las siguientes lineas

hostname "NGN-FREE"
y
rcon_password "abc123"

cd /home/csserver/27020

Para Lanzar y testear el server OJO en IP debe ir tu IP Publica xxx.xxx.xxx.xxx | www.cual-es-mi-ip.net/

./hlds_run -game cstrike +ip 180.1.1.200 +port 27016 -pingboost 3 +maxplayers 22 +map de_dust -autoupdate

Para finalizar presiona control + C

Ahora, si quieres cerrar tu ventana y que el hlds_run corra como servicio

screen -A -m -d -S csserver ./hlds_run -game cstrike +ip xxx.xxx.xxx.xxx +port 27016 -pingboost 3 +maxplayers 22 +map de_dust -autoupdate &

Para activar de Dproto (NoSteam) Dual-Protocol
Crear el archivo dproto.cfg en /home/csserver/27020/

touch /home/csserver/27020/dproto.cfg

Editar

nano /home/csserver/27020/dproto.cfg

Pegar el siguiente contenido

http:// paste bin .com /crb5bNk5

Agregar en la configuración de /home/csserver/27020/cstrike/server.cfg

dp_rejmsg_nosteam47 "Sorry, you're using old client, download a new one and come back

En caso de querer actualizar nuestro server NO RECOMENDADO
cd /home/csserver

iptables -A INPUT -p udp -m udp --sport 27000:27030 --dport 1025:65355 -j ACCEPT
iptables -A INPUT -p udp -m udp --sport 4380 --dport 1025:65355 -j ACCEPT

wget http://media.steampowered.com/client/steamcmd_linux.tar.gz
tar xvfz steamcmd_linux.tar.gz

chmod +x steamcmd.sh
./steamcmd.sh

login anonymous

//Ojo debes incluir la ruta de tu cs, si seguiste el manual al pie de la letra sera.

force_install_dir /home/csserver/27020/

Para Actualizar
app_update 90 update

Para validar instalación OJO se des configura, es importante guardar los archivos de configuración .ini .gam entre otros.

app_update 90 update

Para instalar hlds beta

app_update 90 -beta beta validate

REFERENCIAS
http://danielgibbs.co.uk/scripts/csserver/

http://amxxforums.com/thread-17.html
