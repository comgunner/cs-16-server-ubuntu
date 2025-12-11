


# HLDS Auto Installer for Ubuntu 24.04  
### Counter-Strike 1.6 Dedicated Server (HLDS) – Automated Setup Script

```bash
wget "https://raw.githubusercontent.com/comgunner/cs-16-server-ubuntu/refs/heads/main/hlds-ubuntu24-installer.sh"
```
```bash
sudo chmod +x hlds-ubuntu24-installer.sh
```
```bash
sudo ./hlds-ubuntu24-installer.sh 
```

---

This repository provides an automated installer for deploying a fully functional  
**Counter-Strike 1.6 HLDS server** on **Ubuntu Server 24.04**, complementing the official tutorial:

➡️ **SourceForge Documentation:**  
https://sourceforge.net/p/cs16serverpreconfiguredlinux/wiki/Ubuntu24_HLDS_Install/

The installer performs Steps **1 through 4.2**, runs a **manual HLDS test**,  
and downloads the systemd service installer **without enabling it automatically**.

---

## Features

- Installs all required 32-bit compatibility libraries.
- Downloads & extracts:
  - Preconfigured HLDS package  
  - SteamCMD
- Applies required library fixes (`steamclient.so`, stdlib patches).
- Optional **DProto dual protocol** support (`--no-steam` flag).
- Manual server test with safe **Ctrl + C** handling.
- Downloads the official systemd service installer for persistent operation.
- Fully compatible with clean Ubuntu Server 24.04 installations.

---

## Why SteamCMD Requires Manual Input

SteamCMD is launched manually during the installation because HLDS is highly sensitive to incorrect directory paths.  
Providing the commands manually ensures a clean and correct installation.

When the SteamCMD console appears, enter exactly:

```bash
force_install_dir /home/csserver/27020/
```
```bash
login anonymous
```
```bash
app_update 90 validate
```
```bash
exit
```




This prevents:

- Path misconfiguration  
- Corrupted validation  
- Cached login issues  
- SteamCMD writing files into the wrong directory  

These manual steps guarantee that AppID **90** (HLDS for CS 1.6) is installed properly.

---

## Understanding the HLDS Test Output

During Step **4.2**, the script launches the HLDS server in foreground mode.  
A successful launch typically looks like this:

Auto-restarting the server on crash
Could not locate steam binary:steamcmd/steamcmd.sh, ignoring.

Console initialized.
Using breakpad crash handler
Protocol version 48
Exe version 1.1.2.7/Stdio (cstrike)
STEAM Auth Server
Server IP address 192.168.1.183:27020




### This means:

- The HLDS server **started successfully**.
- It is listening on the selected IP and port.
- It is running **protocol 48**, required by CS 1.6.
- The message about `steamcmd.sh` is **normal** and not an error.

### Stopping the test server

Press:

Ctrl + C




The script safely terminates HLDS and continues to the next steps.

---

## Installation Completed

At the end of the script you will see:

INSTALLATION FLOW COMPLETED
CS 1.6 server installed at: /home/csserver/27020
Systemd installer script at:
/home/csserver/install_cstrike_service.sh

bash


To manually start another HLDS test:

```bash
sudo -u csserver -H bash -lc
"cd '/home/csserver/27020' && ./hlds_run -game cstrike +ip YOUR_IP +port 27020
-pingboost 3 +maxplayers 22 +map de_dust -autoupdate"
```



---

## Installing the Persistent System Service (systemd)

The installer script downloaded by this tool is located at:

/home/csserver/install_cstrike_service.sh

csharp


Run it as a sudo-capable user:

```bash
sudo /home/csserver/install_cstrike_service.sh
```



The service installer will:

- Ask for your public or LAN IP  
- Ask for the port  
- Create the `cstrike.service` unit  
- Enable HLDS to start automatically at boot  

You can manage the server with:

```bash
sudo systemctl start cstrike
sudo systemctl stop cstrike
sudo systemctl restart cstrike
sudo systemctl status cstrike
```



---

## Optional: Dual Protocol Mode (Steam + Non-Steam)

To enable support for both Steam and Non-Steam 47/48 clients, use:

```bash
sudo ./hlds-ubuntu24-installer.sh --no-steam
```




This option:

- Downloads `dproto.cfg`
- Adds a message for outdated client rejections
- Activates dual protocol handling

---

## Requirements

- Ubuntu Server 24.04 (fresh installation recommended)
- A user with sudo privileges  
- Stable internet connection  
- At least 2 GB of free disk space  

---

## Credits

Based on the official SourceForge project:  
https://sourceforge.net/p/cs16serverpreconfiguredlinux/

Script enhancements and automation by **[comgunner]**

---

## License

MIT License — Free for personal and commercial use.

