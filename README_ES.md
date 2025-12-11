# Instalador Automático HLDS para Ubuntu 24.04  
### Servidor Dedicado Counter-Strike 1.6 (HLDS) – Script de Instalación Automatizada

Este repositorio proporciona un instalador automatizado para desplegar un servidor  
**Counter-Strike 1.6 HLDS** completamente funcional en **Ubuntu Server 24.04**, complementando el tutorial oficial:

wget "https://raw.githubusercontent.com/comgunner/cs-16-server-ubuntu/refs/heads/main/hlds-ubuntu24-installer.sh"
sudo chmod +x hlds-ubuntu24-installer.sh
sudo ./hlds-ubuntu24-installer.sh

---

➡️ **Documentación en SourceForge:**  
https://sourceforge.net/p/cs16serverpreconfiguredlinux/wiki/Ubuntu24_HLDS_Install/

El script ejecuta los pasos **1 al 4.2**, realiza una **prueba manual del servidor**,  
y descarga el instalador del servicio systemd **sin activarlo automáticamente**.

---

## Características

- Instalación completa de librerías de compatibilidad de 32 bits.
- Descarga y extracción de:
  - Paquete HLDS preconfigurado  
  - SteamCMD
- Aplicación de fixes necesarios (`steamclient.so`, librerías estándar).
- Soporte opcional para **DProto (dual protocol)** mediante el flag `--no-steam`.
- Prueba manual con manejo seguro de **Ctrl + C**.
- Descarga del instalador systemd oficial para ejecución permanente.
- Compatible con instalaciones limpias de Ubuntu Server 24.04.

---

## ¿Por qué SteamCMD requiere comandos manuales?

El proceso con SteamCMD se realiza manualmente porque HLDS es muy sensible a rutas incorrectas.  
Ingresar los comandos manualmente garantiza una instalación limpia y sin corrupción.

Al abrir SteamCMD, debes escribir exactamente:

force_install_dir /home/csserver/27020/
login anonymous
app_update 90 validate
exit




Esto evita:

- Archivos instalados en el directorio equivocado  
- Validaciones corruptas  
- Problemas con caché de sesiones  
- Reescritura accidental de carpetas del sistema  

De esta forma se asegura que el AppID **90** (HLDS de CS 1.6) se instale correctamente.

---

## Interpretación de la salida del servidor durante la prueba

En el paso **4.2**, el script inicia el servidor HLDS en modo interactivo.  
Una ejecución correcta mostrará algo similar a:

Auto-restarting the server on crash
Could not locate steam binary:steamcmd/steamcmd.sh, ignoring.

Console initialized.
Using breakpad crash handler
Protocol version 48
Exe version 1.1.2.7/Stdio (cstrike)
STEAM Auth Server
Server IP address 192.168.1.183:27020




### Esto significa:

- El servidor HLDS **inició correctamente**.  
- Está escuchando en la IP y puerto seleccionados.  
- Usa **protocolo 48**, requerido por CS 1.6.  
- El mensaje sobre `steamcmd.sh` es **normal** y no indica un error.  

### Para detener el servidor de prueba

Presiona:

Ctrl + C




El script finalizará el proceso HLDS de forma segura y continuará la instalación.

---

## Instalación completada

Al finalizar, verás:

INSTALLATION FLOW COMPLETED
CS 1.6 server installed at: /home/csserver/27020
Systemd installer script at:
/home/csserver/install_cstrike_service.sh




Para ejecutar otra prueba manual:

sudo -u csserver -H bash -lc
"cd '/home/csserver/27020' && ./hlds_run -game cstrike +ip TU_IP +port 27020
-pingboost 3 +maxplayers 22 +map de_dust -autoupdate"




---

## Instalación del servicio permanente (systemd)

El script descarga, pero **no ejecuta**, el instalador del servicio systemd.  
Se encuentra en:

/home/csserver/install_cstrike_service.sh




Para instalar el servicio:

sudo /home/csserver/install_cstrike_service.sh




Este instalador:

- Solicita IP y puerto  
- Crea el archivo `cstrike.service`  
- Habilita el servidor para iniciar automáticamente con el sistema  

Comandos de administración del servicio:

sudo systemctl start cstrike
sudo systemctl stop cstrike
sudo systemctl restart cstrike
sudo systemctl status cstrike




---

## Modo opcional: DProto (Steam + No-Steam)

Para habilitar soporte dual (protocolo 47/48), ejecuta:

sudo ./hlds-ubuntu24-installer.sh --no-steam




Esto configura automáticamente:

- `dproto.cfg`  
- Mensaje de rechazo para clientes obsoletos  
- Compatibilidad dual para Steam y No-Steam  

---

## Requisitos

- Ubuntu Server 24.04 (recomendado en instalación limpia)  
- Usuario con permisos `sudo`  
- Conexión a Internet  
- ~2 GB de espacio disponible  

---

## Créditos

Basado en el proyecto oficial de SourceForge:  
https://sourceforge.net/p/cs16serverpreconfiguredlinux/

Instalador ampliado y automatizado por: **[comgunner]**

---

## Licencia

MIT License – Libre para uso personal y comercial.
