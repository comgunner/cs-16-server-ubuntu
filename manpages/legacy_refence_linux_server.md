legacy_refence_linux_server.md

Title : csserver: Counter Strike 1.6 Linux Server Manager
Origin : https://web.archive.org/web/20131202233938/http://danielgibbs.co.uk/scripts/csserver/

About csserver
Important: There is a bug with SteamCMD; any server using appid 90 (Counter Strike 1.6 and other games) currently requires multiple install attempts before the game’s files are fully installed. On the first several install attempts files may appear to download quickly, but this means that not all server files have actually been downloaded. You must keep trying until the server files start downloading correctly. The server will not work until it has fully downloaded from SteamCMD. The author of this script is not responsible for SteamCMD and cannot resolve this issue. This behavior is consistent with reports from the community that SteamCMD appid 90 often requires repeated runs to complete downloads. :contentReference[oaicite:0]{index=0}

csserver is a command line tool for quick, simple deployment and management of a Counter Strike 1.6 Linux dedicated server. It is part of the Linux Game Server Managers (LinuxGSM) suite which provides automated installation of game servers, use of SteamCMD for updates, server monitoring, and convenience commands. :contentReference[oaicite:1]{index=1}

Current Version: 101113

Main features
Server installer (SteamCMD)
Start/Stop/Restart server
Server update (SteamCMD)
Server monitor (including email notification)
Server backup
Server console

Compatibility
The Linux Server Manager is tested to work on the following Linux systems:
Debian based distros (Ubuntu, Mint, etc.)
Redhat based distros (CentOS, Fedora, etc.)
The scripts are written in BASH and Python and would probably work with other distros as long as required tools like tmux are present. :contentReference[oaicite:2]{index=2}

Installation
The installer will automatically download and configure a Counter Strike 1.6 server.

Prerequisites
Before installing, ensure you have all the dependencies required to run the script.

Debian/Ubuntu 32-bit systems typically need tools like wget, curl, tar, mailutils, unzip, nano and tmux installed. Debian/Ubuntu 64-bit may additionally require 32-bit support libraries. Red Hat/CentOS systems similarly require wget, curl, tar, mailx/unzip, nano and tmux, with additional 32-bit libraries for 64-bit. :contentReference[oaicite:3]{index=3}

Install
1. Create a user and login:
adduser csserver
passwd csserver
su - csserver

2. Download the script:
wget https://raw.github.com/dgibbs64/linuxgameservers/master/CounterStrike/csserver

3. Make it executable:
chmod +x csserver

4. Run the installer and follow the instructions. Note again the SteamCMD appid 90 bug that may require multiple install attempts before the server files are fully downloaded:
./csserver install

Usage
Running the server

Start the server:
./csserver start

Stop the server:
./csserver stop

Restart the server:
./csserver restart

Updating the server
The server can be updated automatically using SteamCMD. The update option will stop the server, run the SteamCMD update, and start the server again:
./csserver update

Monitoring the server
The script can monitor the server to ensure it stays online. Should the server go offline, the monitor will attempt to restart it:
./csserver monitor

Email notification
Monitoring can be configured to send an email if the server goes offline and report details of the issue. To enable email notification, edit the csserver script to set emailnotification to “on” and provide a valid email address. The email-test command allows you to test notifications:
./csserver email-test

Debug mode
Debug mode outputs server activity directly to your terminal for diagnosing issues:
./csserver debug

Server Details
To fetch main server details such as server name, server ports, Rcon password, WebAdmin username and password (if applicable), use:
./csserver details

Console mode
Console mode lets you view the live console of the server as it is running and enter commands directly. To exit the console press “CTRL+b d”; pressing “CTRL+c” will terminate the server:
./csserver console

Backup
The backup feature allows you to create a gzip archive of the entire server. This is useful for making backups before major changes:
./csserver backup

Automation
You can use cronjobs to automate updating and monitoring the server. These can be set up to run as root or as the csserver user.

Example cronjobs:
Update the server daily at 5am:
0 5 * * * su - csserver -c '/home/csserver/csserver update' > /dev/null 2>&1

Monitor the server every 5 minutes:
*/5 * * * * su - csserver -c '/home/csserver/csserver monitor' > /dev/null 2>&1

Configuration
Start parameters:
If needed, you can adjust start parameters by editing the ‘parms’ variable under Start vars in the script. Typical parms might include game mode, IP address, max players and default map.

Config File
The server has a default config file which allows many settings to be edited. Use the details command to locate the config file.

Default ports:
Gameport (Inbound): 27015 UDP
Source TV (Inbound): 27020 UDP
Client Port (Outbound): 27005 UDP
If you need to change ports, edit the respective variables to meet your server requirements.

Multiple Servers
It is possible to run multiple server instances by repeating the installation under separate user accounts and adjusting default ports accordingly.

Running as root
The script will not run as root and will error if attempted. This design prevents permissions issues such as root owning updated files which would prevent the csserver user from accessing them.

Useful Resources
SteamCMD is Valve’s command line tool for installing and updating dedicated server files. :contentReference[oaicite:4]{index=4}
LinuxGSM provides tools for deploying and managing dedicated game servers, including Counter Strike 1.6. :contentReference[oaicite:5]{index=5}
Community discussions confirm the SteamCMD appid 90 bug requiring multiple install attempts. :contentReference[oaicite:6]{index=6}

Issues and troubleshooting
If you find a bug or have a suggestion please submit a bug report on the LinuxGSM GitHub repository. If you have a question about the server that is not related to the script itself, please check the official game resources. If issues arise in getting the script to work you may not have followed instructions correctly; retrying installation or verifying dependencies and permissions often resolves common problems.

GitHub
This script is developed and maintained via GitHub:
https://github.com/dgibbs64/linuxgameservers

Further notes
This script is free to use and you are welcome to customize and change it. The goal is to make it easier to manage a Counter Strike 1.6 server and reduce the manual workload normally required.


