legacy_refence_steamCMD.md

Title : How to make a SteamCMD CS 1.6 server on Linux
Origin :
https://web.archive.org/web/20150610013941/http://amxxforums.com/thread-17.html

Guide : How to make a SteamCMD CS 1.6 server on Linux
How to make and install a CS 1.6 2013 server with SteamCMD on Linux (Debian)
Author: Gam3ronE

This guide will show you how to install a CS 1.6 (Counter-Strike 1.6) 2013 server with SteamCMD on Linux, because it’s popular and Windows is already straightforward. After that you may want to install Metamod, which is a plugin allowing you to run custom modifications (for example AMX Mod X) on Goldsource-based game servers including CS 1.6, Half Life, Day of Defeat and Team Fortress Classic. Many community guides online describe similar processes for installing a CS 1.6 server using SteamCMD, where SteamCMD downloads the server files with the appid 90 for CS 1.6. ([steamcmd developer docs](https://developer.valvesoftware.com/wiki/SteamCMD)) :contentReference[oaicite:0]{index=0}

We assume that you already have Linux installed with Debian and you are in the directory where you want the SteamCMD folder to contain your new SteamCMD based server.

Step 1
Make a new directory called SteamCMD.

Code:
mkdir SteamCMD

Step 2
Download the SteamCMD update tool.

Code:
wget http://media.steampowered.com/client/steamcmd_linux.tar.gz

Step 3
If you are running 64-bit Linux you need to download 32-bit libraries. Otherwise skip to step 4.

Code:
apt-get install ia32-libs

If you get an error you may want to run these commands:
dpkg --add-architecture i386
apt-get update
apt-get install ia32-libs

SteamCMD on 64-bit Debian often requires adding the i386 architecture and installing 32-bit support libraries so that the SteamCMD tool can run properly and download 32-bit server binaries. :contentReference[oaicite:1]{index=1}

Step 4
To ensure that you don’t get a “download failed” error, allow the SteamCMD ports in your firewall.

Code:
iptables -A INPUT -p udp -m udp --sport 27000:27030 --dport 1025:65355 -j ACCEPT
iptables -A INPUT -p udp -m udp --sport 4380 --dport 1025:65355 -j ACCEPT

Some practical guides recommend opening SteamCMD and server related UDP ranges to allow the server files and SteamCMD traffic to pass. :contentReference[oaicite:2]{index=2}

Step 5
Extract the contents of the SteamCMD tar.gz archive.

Code:
tar xvfz steamcmd_linux.tar.gz

Step 6
Now launch SteamCMD.

Code:
./steamcmd.sh

You will see updates downloading and installing, followed by “Loading Steam#…OK”.

Step 7
To download most game servers you can login anonymously.

Code:
login anonymous

Step 8
Now set a directory for your first server to install in. The guide calls it 27020.

Code:
force_install_dir ./27020/

Step 9
Now install the server by doing an app update command with the application ID of the server you want to install. The Counter-Strike 1.6 dedicated server uses appid 90.

Code:
app_update 90

You will see the server download. Eventually you will see “Success! App ’90’ fully installed.” Adding the word validate would verify that all files are correct and force a full verification.

Step 10
To install the HLDS Beta you must do:

Code:
app_update 90 -beta beta validate

Step 11
You may now exit SteamCMD.

Code:
exit

Step 12
The server can be started in the same way as before.

Code:
./hlds_run

Launching the installed server executable like hlds_run typically starts the dedicated server using the installed server files. :contentReference[oaicite:3]{index=3}

Step 13
From here you may wish to learn how to install Metamod and then how to install AMX Mod X, which allow plugins and enhanced functionality on a CS 1.6 server. Other community guides describe installing Metamod and AMX Mod X into the cstrike directory under addons and configuring them accordingly. :contentReference[oaicite:4]{index=4}

If you found that useful feel free to check out other server guides.

Usage
Running the server:

Start the server:
./hlds_run

Further setup such as specifying game modes, maximum players and map options is usually done through command-line parameters provided to the hlds_run executable or through a startup script. :contentReference[oaicite:5]{index=5}

Default ports for a Counter-Strike 1.6 server are typically UDP/TCP 27015, which should be opened on your firewall if you want players to connect from outside. :contentReference[oaicite:6]{index=6}

Metamod installation and plugins
After your CS 1.6 server is running, you can install Metamod manually by extracting the Metamod Linux binary into the cstrike/addons/metamod folder and adding a reference to the Metamod shared object in the game’s configuration files. Then to install AMX Mod X, extract the AMX Mod X base and cstrike addons into the appropriate directories and add plugin references to plugins.ini under addons/metamod. :contentReference[oaicite:7]{index=7}

Useful notes
• If SteamCMD finishes downloading too quickly it often means not all files downloaded. Repeating app_update until a full download completes is a common practice described by SteamCMD users. :contentReference[oaicite:8]{index=8}  
• Making sure 32-bit libraries and dependencies are installed helps avoid errors with SteamCMD on 64-bit systems. :contentReference[oaicite:9]{index=9}


