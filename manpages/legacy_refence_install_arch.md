ACTUALIZADO 2017 ARCHLINUX

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
