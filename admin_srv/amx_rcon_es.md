# Guía de Comandos: AMX Mod X y RCON

Esta guía documenta los comandos esenciales para la administración de servidores de Counter-Strike utilizando AMX Mod X y la consola remota (RCON).

## 🟢 Introducción: Cómo usar la consola

Para introducir estos comandos, debes tener activada la consola de desarrollador en tu juego.

1.  Abre el juego.
2.  Presiona la tecla **`~`** (o la tecla asignada, usualmente debajo de 'Esc' o a la izquierda del '1', como `º` o `ñ` dependiendo del teclado).
3.  Escribe el comando deseado y presiona **Enter**.

> **Nota:** Para comandos de AMX, generalmente necesitas ser administrador con los "flags" (permisos) correctos en el archivo `users.ini`. Para RCON, necesitas la contraseña maestra del servidor.

---

## I. Comandos AMX Mod X (Admin)

Estos comandos son utilizados por los administradores dentro del juego para gestionar la partida y los jugadores.

### 📋 Menú Principal
* `amxmodmenu`: Abre el menú visual principal de administración (la forma más fácil de administrar).

### 👮 Gestión de Jugadores (Castigos y Bans)
* `amx_ban <tiempo> <nick/userid> [razón]`: Baneo general. Expulsa al jugador y lo añade a la lista de baneados.
* `amx_banip <tiempo> <nick/userid> [razón]`: Baneo por IP. Expulsa inmediatamente y banea la dirección IP.
* `amx_unban <IP/AuthID>`: Desbanea a un jugador específico.
* `amx_slap <nick> [daño]`: "Abofetea" al jugador, lanzándolo contra las paredes cercanas (con o sin daño).
* `amx_slay <nick>`: Mata instantáneamente al jugador.
* `amx_slayteam <CT/T>`: Mata a todo un equipo completo.
* `amx_who`: Muestra una lista de los jugadores conectados y sus niveles de acceso.

### 💬 Chat y Mensajería
* `amx_say <mensaje>`: Muestra un mensaje a todos los jugadores en el chat normal (centro de pantalla o chat box).
* `amx_csay <color> <mensaje>`: Muestra un mensaje centrado en la pantalla (HUD).
* `amx_ssay <mensaje>`: Envía un mensaje a todos como administrador anónimo (sin mostrar quién lo envió).
* `amx_psay <nick> <mensaje>`: Envía un mensaje privado a un jugador específico.

### ⚙️ Configuración del Servidor y Juego
* `amx_cvar sv_password "contraseña"`: Establece una contraseña para entrar al servidor.
* `amx_cvar sv_password ""`: Elimina la contraseña del servidor (lo hace público de nuevo).
* `amx_pass <contraseña>`: Atajo para poner contraseña al servidor.
* `amx_nopass`: Atajo para quitar la contraseña del servidor.
* `amx_pause`: Pausa el juego (requiere que el servidor soporte pausas).
* `amx_friendlyfire <0/1>`: Activa (1) o desactiva (0) el fuego amigo.
* `amx_gravity <valor>`: Cambia la gravedad del servidor (800 es el estándar).
* `amx_restrictallweapons`: Prohíbe la compra y uso de todas las armas.
* `amx_servercfg`: Recarga el archivo `server.cfg` principal.
* `amx_reload`: Recarga los archivos de configuración de AMX (como `admins.ini`, `plugins.ini`).

### 🗺️ Mapas y Rondas
* `amx_nextmap`: Muestra cuál será el siguiente mapa en el ciclo.
* `amx_timeleft`: Muestra cuánto tiempo queda para que termine el mapa actual.
* `amx_restart`: Reinicia la ronda (reinicio rápido).
* `amx_fraglimit <valor>`: Establece el límite de frags para cambiar de mapa.
* `amx_timelimit <valor>`: Establece el límite de tiempo (en minutos) por mapa.
* `amx_ct <nick>`: Fuerza a un jugador a moverse al equipo CT.
* `amx_t <nick>`: Fuerza a un jugador a moverse al equipo Terrorista.

---

## II. Comandos RCON (Consola Remota)

RCON ("Remote Console") te da control total sobre el servidor, incluso sin AMX Mod X. Es la consola "raíz" del servidor.

### 🔌 Conexión RCON
Para usar RCON, primero debes autenticarte o definir a qué servidor te conectas (si no estás dentro de él).

* `rcon_password <contraseña>`: Autentícate como admin principal usando la contraseña del `server.cfg`.
* `rcon_address <IP>`: Define la IP del servidor al que quieres enviar comandos (si administras remotamente).
* `rcon_port <puerto>`: Define el puerto del servidor (ej. 27015).

### 🛠️ Control del Servidor vía RCON
Una vez autenticado, usas el prefijo `rcon` antes del comando, o `amx_rcon` si usas el plugin de AMX para enviarlo.

* `amx_rcon <comando>`: Ejecuta un comando de consola de servidor a través de AMX Mod X.
* `rcon sv_restart <1>`: Reinicia la partida en 1 segundo.
* `rcon changelevel <mapa>`: Cambia el mapa inmediatamente (ej. `rcon changelevel de_dust2`).
* `rcon sv_password <pass>`: Cambia la contraseña del servidor desde la consola raíz.
* `rcon hostname <nombre>`: Cambia el nombre visible del servidor.
* `rcon sv_lan <0/1>`: Cambia el modo entre LAN (1) e Internet (0).
* `rcon mp_timelimit <0>`: Elimina el límite de tiempo del mapa (0 = infinito).
* `rcon mp_winlimit <rondas>`: Establece el límite de rondas ganadas para terminar el mapa.
* `csstats_reset 1`: Reinicia las estadísticas del servidor (Rank, Top15).

---

## 📚 Definiciones

| Término | Definición |
| :--- | :--- |
| **AMX Mod X** | Un plugin de metamod que permite la administración avanzada, scripts y plugins personalizados para el servidor. |
| **RCON** | "Remote Console". Es el protocolo base de Valve que permite cambiar valores profundos del servidor (cvars) de forma remota. |
| **CVAR** | "Console Variable". Son las variables de configuración del juego (ej. `mp_friendlyfire`, `sv_gravity`). |
