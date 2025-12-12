# Command Guide: AMX Mod X and RCON

This document outlines the essential commands for Counter-Strike server administration using AMX Mod X and the Remote Console (RCON).

## 🟢 Introduction: How to use the Console

To enter these commands, you must have the developer console enabled in your game.

1.  Launch the game.
2.  Press the **`~`** key (tilde), usually located below 'Esc' or to the left of the '1' key.
3.  Type the desired command and press **Enter**.

> **Note:** For AMX commands, you generally need to be an admin with the correct flags in the `users.ini` file. For RCON, you need the server's master password.

---

## I. AMX Mod X Commands (Admin)

These commands are used by in-game administrators to manage the match and players via the AMX Mod X plugin.

### 📋 Main Menu
* `amxmodmenu`: Opens the main visual administration menu (the easiest way to manage the server).

### 👮 Player Management (Punishment & Teams)
* `amx_ban <time> <nick/userid> [reason]`: General BAN. Kicks the player and adds them to the ban list.
* `amx_banip <time> <nick/userid> [reason]`: IP BAN. Kicks the player immediately and bans their IP address.
* `amx_unban <IP/AuthID>`: Unbans a specific player.
* `amx_slap <nick> [damage]`: Slaps the player, throwing them against nearby walls (with or without damage).
* `amx_slay <nick>`: Instantly kills the player.
* `amx_slayteam <CT/T>`: Kills an entire team.
* `amx_ct <nick>`: Forces a player to join the CT team.
* `amx_t <nick>`: Forces a player to join the Terrorist team.
* `amx_who`: Shows a list of connected players and their access levels.

### 💬 Chat and Communication
* `amx_say <message>`: Displays a message to all players in the standard chat (center screen or chat box).
* `amx_csay <color> <message>`: Displays a centered HUD message on the screen.
* `amx_ssay <message>`: Sends a message to everyone as an anonymous admin (hides the sender's name).
* `amx_psay <nick> <message>`: Sends a private message to a specific player.

### ⚙️ Server & Game Configuration
* `amx_cvar sv_password "password"`: Sets a password for the server (locks it).
* `amx_cvar sv_password ""`: Removes the server password (makes it public).
* `amx_pass <password>`: Shortcut to set the server password.
* `amx_nopass`: Shortcut to remove the server password.
* `amx_pause`: Pauses the game (requires server pause support).
* `amx_friendlyfire <0/1>`: Enables (1) or disables (0) friendly fire.
* `amx_gravity <value>`: Sets the server gravity (Default is 800).
* `amx_restrictallweapons`: Prohibits purchasing and using all weapons.
* `amx_servercfg`: Reloads the main `server.cfg` file.
* `amx_reload`: Reloads AMX configuration files (e.g., `admins.ini`, `plugins.ini`).

### 🗺️ Maps and Rounds
* `amx_nextmap`: Shows the next map in the cycle.
* `amx_timeleft`: Shows the time remaining on the current map.
* `amx_restart`: Restarts the round (fast reload).
* `amx_fraglimit <value>`: Sets the frag limit required to change the map.
* `amx_timelimit <value>`: Sets the time limit (in minutes) per map.

---

## II. RCON Commands (Remote Console)

RCON ("Remote Console") gives you total control over the server engine, even without AMX Mod X. It is the "root" console of the server.

### 🔌 RCON Connection
To use RCON, you must first authenticate or define which server you are connecting to (if you are not inside it).

* `rcon_password <password>`: Authenticate as the main admin using the password set in `server.cfg`.
* `rcon_address <IP>`: Define the server IP you want to send commands to (for remote administration).
* `rcon_port <port>`: Define the server port (e.g., 27015).

### 🛠️ Server Control via RCON
Once authenticated, use the `rcon` prefix before the command, or `amx_rcon` if using the AMX plugin to bridge the command.

* `amx_rcon <command>`: Executes a server console command via AMX Mod X.
* `rcon sv_restart <1>`: Restarts the match in 1 second.
* `rcon changelevel <mapname>`: Changes the map immediately (e.g., `rcon changelevel de_dust2`).
* `rcon sv_password <pass>`: Changes the server password from the root console.
* `rcon hostname <name>`: Changes the visible server name.
* `rcon sv_lan <0/1>`: Toggles between LAN (1) and Internet (0) mode.
* `rcon mp_timelimit <0>`: Removes the map time limit (0 = infinite).
* `rcon mp_winlimit <rounds>`: Sets the limit of won rounds to end the map.
* `csstats_reset 1`: Resets server statistics (Rank, Top15).

---

## 📚 Definitions

| Term | Definition |
| :--- | :--- |
| **AMX Mod X** | A Metamod plugin that enables advanced administration, scripting, and custom plugins for the server. |
| **RCON** | "Remote Console." Valve's base protocol that allows changing deep server values (cvars) remotely. |
| **CVAR** | "Console Variable." Game configuration variables (e.g., `mp_friendlyfire`, `sv_gravity`). |
