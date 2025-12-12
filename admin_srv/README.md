# CS 1.6 Server Administration - Quick Start

Welcome to the basic administration guide for Counter-Strike 1.6 servers. This repository provides reference documentation for managing your server using **AMX Mod X** and **RCON**.

## 🚀 Getting Started

To administer the server, you must use the **Developer Console**.
* **Open Console:** Press the **`~`** key (tilde) while in-game.

### 🔑 Authentication & Files
It is important to know which file controls your access:

* **AMX Mod X (Admin Rights):**
    * **File:** `users.ini` (located in `addons/amxmodx/configs/`)
    * **Usage:** Your admin flags (permissions) are defined here. This file is **separate** from server.cfg.

* **RCON (Server Root Control):**
    * **File:** `server.cfg`
    * **Usage:** The master password is set here. You log in via console:
        ```bash
        rcon_password "your_password"
        ```
    * *Note:* This password is set in `server.cfg`.

---

## ⚡ The Essentials (Cheat Sheet)

If you only remember one command, make it this one:

### `amxmodmenu`
This opens the main visual menu. From here, you can kick, ban, change maps, and configure the server without remembering complex codes.

### Common Quick Commands
| Command | Description |
| :--- | :--- |
| `amx_map <mapname>` | Change the map immediately. |
| `amx_banmenu` | Opens the ban menu directly. |
| `rcon changelevel <map>` | Force a map change via RCON. |
| `rcon sv_restart 1` | Restart the match round. |

---

## 📖 Full Documentation

For a complete list of commands, variable definitions, and categorized functions, please refer to the detailed guides included in this repository:

* **🇺🇸 [English Guide (amx_rcon.md)](./amx_rcon.md)** - Full command list and explanations.
* **🇪🇸 [Guía en Español (amx_rcon_es.md)](./amx_rcon_es.md)** - Lista completa de comandos y explicaciones.

> **Note:** **AMX Mod X** commands are for general gameplay management, while **RCON** commands control the server engine directly.
